package controller

import (
	"encoding/json"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/litec-thesis/2223-thesis-5abhit-zoecbe_mayrjo_grupa-cardstorage/api/util"
)

//go:generate go-enum --marshal
/* ENUM(
	success,
	failure,

	storage-unit-ping,
	storage-unit-new,

	storage-unit-new-card,
	storage-unit-delete-card,
	storage-unit-fetch-card-source-mobile,
	storage-unit-fetch-card-source-terminal,

	user-signup-source-mobile,
	user-signup-source-terminal,
	user-check-exists
)
*/
type Action string

type ActionHandler interface {
	func(mqtt.Message) error
}

func ActionsToJSON() ([]byte, error) {
	return json.Marshal(util.Keys(_ActionValue))
}