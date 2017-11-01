require 'socket'

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
      body = response.split("\n\n")[1]
      puts
      print body
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
