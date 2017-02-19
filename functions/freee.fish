set -g -x CLIENT_ID ""
set -g -x CLIENT_SECRET ""
set -g -x AUTHORIZATION_CODE ""
set -g -x REDIRECT_URI "urn:ietf:wg:oauth:2.0:oob"

function __setup_variables
    set CLIENT_ID eval(cat ~/.freeerc/CLIENT_ID)
    set CLIENT_SECRET eval(cat ~/.freeerc/CLIENT_SECRET)
    set AUTHORIZATION_CODE eval(cat ~/.freeerc/AUTHORIZATION_CODE)

    if [ $CLIENT_ID ]
        # ok
    else
        echo '> set client id from https://secure.freee.co.jp/oauth/applications/.'
        echo 'set CLIENT_ID "your App ID"'
        return
    end

    if [ $CLIENT_SECRET ]
        # ok
    else
        echo '> set client secret from https://secure.freee.co.jp/oauth/applications/.'
        echo 'set CLIENT_SECRET "your app Secret"'
        return
    end

    # https://secure.freee.co.jp/oauth/authorize?client_id=${お客様のApp ID}&redirect_uri=${お客様のコールバックURI}&response_type=code
    echo '> set Authorization code from logging in https://secure.freee.co.jp/oauth/authorize?client_id='$CLIENT_ID'&redirect_uri='$REDIRECT_URI'&response_type=code.'
    echo 'set AUTHORIZATION_CODE "your Authorization code"'
end

function __get_access_token
    __setup_variables
    if [ $AUTHORIZATION_CODE != '' ]
        # ok
        echo 'ok'
        return 0
    else
        # get authorization code 
        __setup_variables
        echo 'ng'
        return 1
    end

    # curl -XPOST -d grant_type=authorization_code -d client_id=${お客様のApp ID} -d client_secret=${お客様のSecret} -d code=${先ほどのauthorization code} -d redirect_uri=${お客様のコールバックURI} "https://api.freee.co.jp/oauth/token"
    curl -XPOST -d grant_type=authorization_code -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d code=$AUTHORIZATION_CODE -d redirect_uri=$REDIRECT_URI "https://api.freee.co.jp/oauth/token"
end

function freee
    if [ __get_access_token  = 1 ]
        # Error
        echo 'Error.'
        return
    end

    echo 'ok.'
echo $AUTHORIZATION_CODE
    curl -i -X GET \
      -H "Authorization:Bearer $AUTHORIZATION_CODE" \
      -H "Content-Type:application/json" \
      'https://api.freee.co.jp/api/1/users/me?companies=true'
end
