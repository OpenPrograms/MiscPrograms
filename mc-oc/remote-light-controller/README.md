# remote-light-controller
*This script will provide an open port and service for tablets. The service will wait for incoming messages or broadcasts, providing remote light control.*

## Synopsis
`light-service`

`light-cli <port> <cmd> <strength>`

`light-standalone <cmd>`


## Description
This program allows the player to control their redstone powered lights via tablet.

## Requirements
* Wireless modem card

## Manuals
`man light-service`

`man light-cli`

`man light-standalone`

## Examples
`light-service`

`light-cli 123 on 15`

`light-cli 123 off 15`

`light-cli 123 kill`

`light-standalone on`

`light-standalone off`
