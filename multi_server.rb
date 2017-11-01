require 'socket'                 # Get sockets from stdlib

def parsing_request(request)
  array_values = request.match(/^(\w+)\s+\/(\w+\.\w+)?\s+HTTP\/(\d+\.?\d+)/)
  $function = array_values[1]
  $file_name = array_values[2]
  $http_version = array_values[3]
end

server = TCPServer.open(2000)    # Socket to listen on port 2000
loop {                           # Servers run forever
   Thread.start(server.accept) do |client|
    request = client.gets
    puts request
    parsing_request(request)
    if $function == "GET" && $file_name != nil
      exist_file = File.exists?($file_name)
      status = exist_file ? "HTTP/#{$http_version} 200 OK" : "HTTP/#{$http_version} 404 Not Found"
      if exist_file
        response = %{#{status}
                      Date: #{Time.now.ctime}
                      Content-Type: text/html
                      Content-Length: #{File.size($file_name)}

                    #{File.read($file_name)}}
      elsif !exist_file
        response = %{#{status}
                      Content-Type: text/html
                      Content-Length: #{File.size("not_found.html")}

                    #{File.read("not_found.html")}}
      end
      client.print(response)
    else
      client.puts(request)
      client.puts(Time.now.ctime)   # Send the time to the client
      client.puts "Closing the connection. Bye!"
    end
    client.close
   end
}
