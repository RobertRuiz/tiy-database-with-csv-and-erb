require 'webrick'

class OurFirstServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    response.body = %{
Hello, world. My favorite number is #{rand(1000)}

<form action="/favorite-color">
  <label for="color">Color:</label>
  <input id="color" name="color" type="text">

  <label for="size">Size:</label>
  <input id="size" name="size" type="text">

  <input type="submit" value="Save">

</form>
}
    response.content_type = "text/html"
    response.status = 200
  end
end

class OurFavoriteColor < WEBrick::HTTPServlet::AbstractServlet
  def initialize(server)
    @colors = []
  end

  def do_GET(request, response)
    @colors << request.query["color"]

    response.body = %{
<html>
<head>
<style>
  body {
    background-color: #{request.query["color"]};
    font-size: #{request.query["size"]}em;
  }
</style>
<body>
  Hey there, my favorite color is #{request.query["color"]} and my favorite size is #{request.query["size"]} <a href='/'>HOME</a>

  I've seen #{@colors.join(",")}
</body>
</html>
}
    response.content_type = "text/html"
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount "/", OurFirstServer
server.mount "/favorite-color", OurFavoriteColor
server.start
