require 'socket'

def parsing_response(response)
  array_values = response.match(/^HTTP\/(\d+\.?\d+)\s+(\d+)\s+(\w+\s+?\w+)/)
  $http_version = array_values[1]
  $number_message = array_values[2]
  $message = array_values[3]
end

hostname = "localhost"
port = 2000

  while true do
    socket = TCPSocket.open(hostname,port)  # Connect to server
    puts %{Enter your action:
1: take a file
2: close_connection}
    case gets.chomp.strip.to_i
    when 1
      puts "Enter a file name:"
      $file_name = gets.chomp.strip
      request = %{GET /#{$file_name} HTTP/1.1
}
      socket.print(request)
      response = socket.read
      parsing_response(response)
      body = response.split("\n\n")[1]
        puts
      if body == nil && $number_message == "404"
        print "#{$number_message} #{$message}"
      elsif $number_message == "200"
        print body
      else
        print "Unknown Error"
      end
      puts
      socket.close
    when 2
      puts "Closing the connection..."
      socket.close
      break
    else
      puts "Try again"
    end
end
