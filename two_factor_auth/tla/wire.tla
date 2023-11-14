---------------------------- MODULE twofa ----------------------------
(*
--algorithm LoginSystem
variables
    CachedLoginData = [username |-> "none", device_id |-> "none"],
    PersistentLoginData = [username |-> "none", password |-> "none"],
    result = "none";

procedure CachedLogin(username, device_id)
begin
    if CachedLoginData[username] = device_id then
        result := ":ok";
    elsif CachedLoginData[username] = "none" then
        result := ":no_user_or_device";
    else
        result := ":wrong_device";
    end if;
end procedure;

procedure SaveToDeviceCache(username, device_id)
begin
    CachedLoginData[username] := device_id;
end procedure;

procedure PersistentLogin(username, password)
begin
    if PersistentLoginData[username] = password then
        result := ":ok";
    elsif PersistentLoginData[username] = "none" then
        result := ":no_user";
    else
        result := ":wrong_password";
    end if;
end procedure;

procedure Register(username, password)
begin
    PersistentLoginData[username] := password;
end procedure;

process LoginProcess = "Login"
variables username, password, device_id;
begin
    Login:
        call CachedLogin(username, device_id);
        if result = ":ok" then
            print("Logged in using cache");
        else
            call PersistentLogin(username, password);
            if result = ":ok" then
                call SaveToDeviceCache(username, device_id);
                print("Logged in using persistent data");
            else
                print("Login failed");
            end if;
        end if;
end process;
end algorithm;


    
*)



=============================================================================
