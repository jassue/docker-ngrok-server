# docker-ngrok-server

Docker image of ngrok server,Based on golang1.7-alpine image.

## Environment variables

You can configure ngrok by setting environment variables.

| Environment variable | Description                                                  | Default    |
| :------------------- | ------------------------------------------------------------ | ---------- |
| `NGROK_DOMAIN`       | Your ngrok server domain name                                | `**None**` |
| `TUNNEL_ADDR`        | The server listens for the tunnel port of the client connection | `8443`     |
| `HTTP_ADDR`          | HTTP port listened by the server                             | `80`       |
| `HTTPS_ADDR`         | HTTPS port listened by the server                            | `443`      |
| `WINDOWS_32`         | Compile the client of the Windows 32-bit system              | `0` (No)   |
| `WINDOWS_64`         | Compile the client of the Windows 64-bit system              | `1` (Yes)  |
| `LINUX_32`           | Compile the client of the Linux 32-bit system                | `0`        |
| `LINUX_64`           | Compile the client of the Linux 64-bit system                | `1`        |
| `LINUX_ARM`          | Compile the client of the ARM system                         | `0`        |
| `DARWIN_32`          | Compile the client of the Mac 32-bit system                  | `0`        |
| `DARWIN_64`          | Compile the client of the Mac 64-bit system                  | `1`        |

## Docker images layout

| File/Directory                          | Description                  |
| --------------------------------------- | ---------------------------- |
| `/go/ngrok/bin/cert`                    | SSL configuration directory  |
| `/go/ngrok/bin/ngrokd`                  | Ngrok server                 |
| `/go/ngrok/bin/ngrok`                   | Linux 64-bit system client   |
| `/go/ngrok/bin/linux_386/ngrok`         | Linux 32-bit system client   |
| `/go/ngrok/bin/linux_arm/ngrok`         | ARM system client            |
| `/go/ngrok/bin/windows_386/ngrok.exe`   | Windows 32-bit system client |
| `/go/ngrok/bin/windows_amd64/ngrok.exe` | Windows 64-bit system client |
| `/go/ngrok/bin/darwin_386/ngrok`        | Mac 32-bit system client     |
| `/go/ngrok/bin/darwin_amd64/ngrok`      | Mac 64-bit system client     |

## Usage

#### 1.Pull docker images

~~~
docker pull jassue/ngrok
~~~

If you pull the image too slowly, you can also build an ngrok image by cloning the git library.

#### 2.Running ngrok server container

~~~
docker run --name ngrok-server -e NGROK_DOMAIN="your domain name" -p 80:80 -p 443:443 -p 8443:8443 -v /data/ngrok:/go/ngrok/bin -d jassue/ngrok
~~~

It takes some time for the container to compile the server and client, you can check the progress by the following command.

~~~
docker logs ngrok-server
~~~

When the log appears `[metrics] Reporting every 30 seconds`, the ngrok server is already running.

#### 3.Configuring and running the client

Place the compiled client on the device you need to use and create the configuration file `ngrok.cfg` in the same path as the client. The specific tunnel configuration method can be seen in the [official documentation](https://ngrok.com/docs).

~~~
server_addr: "your domain name:8443"
trust_host_root_certs: false
tunnels:
    test:
        subdomain: "test"
        proto:
            http: 80
~~~

Start the client

~~~
./ngrok -config=ngrok.cfg start test
~~~

After pressing the Enter key, when you see `Tunnel Status online`, the client successfully starts.
