// https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_a_WebSocket_server_in_JavaScript_Deno
Deno.serve({
  port: 54321,
  handler: async (request) => {
    // If the request is a websocket upgrade,
    // we need to use the Deno.upgradeWebSocket helper
    if (request.headers.get("upgrade") === "websocket") {
      console.log("websocket");
      const { socket, response } = Deno.upgradeWebSocket(request);

      socket.addEventListener("open", () => {
        console.log("CONNECTED");
      });
      socket.addEventListener("message", (event) => {
        console.log(`RECEIVED: ${event.data}`);
        socket.send("pong");
      });
      socket.addEventListener("close", () => console.log("DISCONNECTED"));
      socket.addEventListener(
        "error",
        (error) => console.error("ERROR:", error),
      );

      return response;
    } else {
      console.log("http");
      // If the request is a normal HTTP request,
      // we serve the client HTML file.
      const file = await Deno.open("./websoc.html", { read: true });
      return new Response(file.readable);
    }
  },
});
