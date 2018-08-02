# remote-door-controller
*This script will provide an open port and service for tablets. The service will wait for incoming messages or broadcasts, providing remote door control.*

## Synopsis
`rd-service`

`rd-cli <port> <cmd> <strength>`

## Description
This program allows the player to control their redstone powered door via tablet.

## Requirements
* Wireless modem card

## Manuals
`man rd-service`

`man rd-cli`

## Examples
`rd-service`

`rd-cli 123 open 3`

`rd-cli 123 close 3`

`rd-cli 123 kill`
