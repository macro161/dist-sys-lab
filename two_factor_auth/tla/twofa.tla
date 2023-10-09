---------------------------- MODULE LoginSystem ----------------------------

VARIABLES cachedDevices, persistentUsers, loginResponse

(* Initialize the system with empty sets *)
Init ==
    cachedDevices = [username \in DOMAIN cachedDevices |-> NULL]
    /\ persistentUsers = [username \in DOMAIN persistentUsers |-> NULL]
    /\ loginResponse = NULL

(* Cached login attempt *)
CachedLogin(username, device_id) ==
    IF cachedDevices[username] = device_id THEN
        loginResponse = <<username, "OK_CACHED">>
    ELSE IF cachedDevices[username] = NULL THEN
        loginResponse = <<username, "NO_USER_OR_DEVICE">>
    ELSE
        loginResponse = <<username, "WRONG_DEVICE">>

(* Persistent login attempt *)
PersistentLogin(username, password) ==
    IF persistentUsers[username] = password THEN
        loginResponse = <<username, "OK_PERSISTENT">>
    ELSE IF persistentUsers[username] = NULL THEN
        loginResponse = <<username, "NO_USER">>
    ELSE
        loginResponse = <<username, "WRONG_PASSWORD">>

(* Register a new user *)
Register(username, password) ==
    persistentUsers' = [persistentUsers EXCEPT ![username] = password]

(* Save device ID in the cache *)
SaveDeviceID(username, device_id) ==
    cachedDevices' = [cachedDevices EXCEPT ![username] = device_id]

(* Login using either cached or persistent mechanism *)
Login(username, password, device_id) ==
    IF cachedDevices[username] = device_id THEN
        CachedLogin(username, device_id)
    ELSE
        PersistentLogin(username, password)
        /\ SaveDeviceID(username, device_id)

Next ==
    \E username \in DOMAIN cachedDevices, password \in DOMAIN persistentUsers, device_id:
        Login(username, password, device_id)
    \/ \E username \in DOMAIN cachedDevices, device_id:
        CachedLogin(username, device_id)
    \/ \E username, password:
        Register(username, password)
    \/ \E username \in DOMAIN cachedDevices, device_id:
        SaveDeviceID(username, device_id)

=============================================================================
