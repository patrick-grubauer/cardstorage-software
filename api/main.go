package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/controller"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/observer"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/response"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

func main() {
	router := mux.NewRouter().PathPrefix("/api").Subrouter()
	router.Headers(
		"Accept", "application/json",
		"Accept-Charset", "utf-8",
		"Server", fmt.Sprintf("card-management@%s", runtime.Version()))

	sitemap := &util.Sitemap{Router: router, Sitemap: make(map[*json.RawMessage]http.Handler)}
	logger := log.New(os.Stderr, "API: ", log.LstdFlags|log.Lshortfile)

	mqc := mqtt.NewClient(mqtt.NewClientOptions().
		SetClientID("CSManagementController").
		AddBroker("tcp://localhost:1883"))
	<-mqc.Connect().Done()

	util.Must(nil, godotenv.Load("api/.env"))
	connstring := fmt.Sprintf("%s:%s@/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWD"),
		os.Getenv("DB_NAME"))

	db := util.Must(sql.Open(os.Getenv("DB_DRIVER"), connstring)).(*sql.DB)
	// messages := make(map[uuid.UUID][]observer.Result)

	(&observer.Observer{Client: mqc, Logger: logger, DB: db}).Observe()

	u := response.User{DB: db, Logger: logger}
	c := response.Card{DB: db, Logger: logger, Client: mqc}
	t := response.CardStatus{DB: db, Logger: logger}
	l := response.Location{DB: db, Logger: logger}
	s := response.StorageUnit{DB: db, Logger: logger}

	logger.Println(string(util.Must(controller.ActionsToJSON()).([]byte)))

	sitemap = sitemap.
		AddHandler(http.MethodOptions, util.API_BASE_PATH, response.OptionsHandler).
		AddHandler(http.MethodGet, util.API_USERS, u.GetAllUsersHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_ID, u.GetUserByIdHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_EMAIL, u.GetUserByEmailHandler).
		AddHandler(http.MethodGet, util.API_USERS_FILTER_READER, u.GetUserByReaderDataHandler).
		AddHandler(http.MethodPost, util.API_USERS_SIGN_UP, u.SignUpHandler).
		AddHandler(http.MethodGet, util.API_CARDS, c.GetAllCardsHandler).
		AddHandler(http.MethodPost, util.API_CARDS, c.AddNewCardHandler).
		AddHandler(http.MethodGet, util.API_CARDS_FILTER_ID, c.GetCardByIdHandler).     // @todo
		AddHandler(http.MethodGet, util.API_CARDS_FILTER_NAME, c.GetCardByNameHandler). // @todo
		AddHandler(http.MethodGet, util.API_CARDS_STATUS, t.GetAllCardsStatusHandler).
		AddHandler(http.MethodGet, util.API_CARDS_STATUS_FILTER_ID, t.GetCardStatusByCardIdHandler).
		AddHandler(http.MethodPut, util.API_CARDS_STATUS, t.PutCardStatusByCardIdHandler). // @todo
		AddHandler(http.MethodGet, util.API_LOCATIONS, l.GetAllLocationsHandler).
		AddHandler(http.MethodGet, util.API_LOCATIONS_FILTER_ID, l.GetLocationByIdHandler).
		AddHandler(http.MethodGet, util.API_LOCATIONS_FILTER_NAME, l.GetLocationByNameHandler).
		AddHandler(http.MethodPost, util.API_LOCATIONS, l.AddNewLocationHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS, s.GetAllStorageUnitsHandler).
		AddHandler(http.MethodPost, util.API_STORAGEUNITS, s.AddNewStorageUnitHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_FILTER_ID, s.GetStorageUnitByIdHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_FILTER_NAME, s.GetStorageUnitByNameHandler).
		AddHandler(http.MethodGet, util.API_STORAGEUNITS_PING_FILTER_ID, s.PingStorageUnitByIdHandler) // @todo

	logger.Println(connstring)

	go func() {
		bytes := util.Must(json.MarshalIndent(util.Keys(sitemap.Sitemap), "", "\t")).([]byte)
		file := util.Must(os.Create("sitemap.json")).(*os.File)
		util.Must(file.Write(bytes))
		util.Must(nil, file.Close())
	}()

	logger.Println(http.ListenAndServe("localhost:7171", handlers.LoggingHandler(logger.Writer(), router)))
}