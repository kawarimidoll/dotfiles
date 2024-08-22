import { serveFile } from "jsr:@std/http/file-server";

// https://docs.deno.com/examples/http-server-websocket/
// https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_a_WebSocket_server_in_JavaScript_Deno
Deno.serve({
  port: 54321,
  handler: async (request) => {
    if (request.headers.get("upgrade") === "websocket") {
      return handleWebsocket(request);
    } else {
      return await handleHttp(request);
    }
  },
});

function currentTime() {
  return (new Date()).toISOString();
}

const sockets = {};

function handleWebsocket(request) {
  console.log("websocket");
  // If the request is a websocket upgrade,
  // we need to use the Deno.upgradeWebSocket helper
  // console.log(request);
  const { socket, response } = Deno.upgradeWebSocket(request);

  // console.log(socket);

  socket.addEventListener("open", () => {
    console.log(`CONNECTED ${currentTime()}`);
  });
  socket.addEventListener("message", (event) => {
    const data = JSON.parse(event.data);
    console.log(`RECEIVED: ${event.data}`);
    // socket.send("pong");
    // socket.send(JSON.stringify(data));
    broadcast(data);
  });
  socket.addEventListener(
    "close",
    () => console.log(`DISCONNECTED ${currentTime()}`),
  );
  socket.addEventListener(
    "error",
    (error) => console.error("ERROR:", error),
  );

  const socketKey = request.headers.get("sec-websocket-key");
  sockets[socketKey] = socket;
  console.log(sockets);

  return response;
}

function broadcast(data) {
  const payload = JSON.stringify(data);
  for (const socket of Object.values(sockets)) {
    socket.send(payload);
  }
}

async function handleHttp(request) {
  console.log(`http ${request.method} ${request.url}`);

  return serveFile(request, "./websoc.html");
}
