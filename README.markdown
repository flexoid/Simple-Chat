## Chat program based on self-developed Simple Chat protocol.

## Protocol description

### Client -> Server direction
* Establish a connection.
 `$u <nickname>`

* Enter the room
 `$j <roomname>`

* Exit the room
 `$p <roomname>`

* Send message to the room
 `$m <roomname> <message>`

* Send message to another client
 `$m <nickname> <message>`

* Get the information about client
 `$i <nickname>`

### Server -> Client direction

* Notifycation about entrance to the room
 `$n <nickname> <roomname>`

* Notifycation about leaving the room
 `$p <nickname> <roomname>`

* List of the clients in the room
 `$l <roomname> <nickname1> <nickname2> … <nicknameN>`

* Message delivery
 `$m <to_roomname> <from_nickname> <message>`
 `$m <from_nickname> <message>`

* Error
 `$e <errorcode> <errorstring>`

* Sending information about the client
 `$i <nickname> <age> [<email>]`
