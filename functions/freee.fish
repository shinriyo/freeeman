set -g -x CLIENT_ID ""
set -g -x CLIENT_SECRET ""
set -g -x AUTHORIZATION_CODE ""
set -g -x REDIRECT_URI "urn:ietf:wg:oauth:2.0:oob"

function __get_access_token
    if [ $CLIENT_ID ]
        # ok
    else
        echo '> set client id.'
        echo 'set CLIENT_ID "your client code"'
        return
    end

    if [ $CLIENT_SECRET ]
        # ok
    else
        echo '> set client secret.'
        echo 'set CLIENT_SECRET "your app secret"'
        return
    end

    if [ $AUTHORIZATION_CODE ]
        # ok
    else
        return
    end

    # curl -XPOST -d grant_type=authorization_code -d client_id=${お客様のApp ID} -d client_secret=${お客様のSecret} -d code=${先ほどのauthorization code} -d redirect_uri=${お客様のコールバックURI} "https://api.freee.co.jp/oauth/token"
    curl -XPOST -d grant_type=authorization_code -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d code=$AUTHORIZATION_CODE -d redirect_uri=$REDIRECT_URI "https://api.freee.co.jp/oauth/token"
end

function freee
    __get_access_token

    return
    curl -i -X GET \
      -H "Authorization:Bearer XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
      -H "Content-Type:application/json" \
      'https://api.freee.co.jp/api/1/users/me?companies=true'
end
