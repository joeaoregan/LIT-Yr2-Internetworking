#!/usr/bin/perl -w
# Filename : jor_s2
# Joe O'Regan

# The Client socket receives a question from the Server socket
# "What is your name?"
# The Client sends a reply string to the Server with the name
# The Server then sends a reply to he Client
# depending on if the name matches the name stored 
# the Server
# If the name is Joe the Server returns a greeting
# otherwise the Client must enter a password
# If the password is correct the Client receives a positive response
# otherwise it must guess the password until it guesses one of the
# answers in the array of passwords

use IO::Socket;

$| = 1;

my $socket = new IO::Socket::INET (
    LocalHost => 'localhost',
    LocalPort => '8000',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port 8000\n";

@words = qw(password open enter);					# Array of passwords
 
while($client_socket = $socket->accept())  
{ 
  my $client_address = $client_socket->peerhost(); 	# Client address
  my $client_port = $client_socket->peerport();		# Client port number
  print "\nNew connection from $client_address:$client_port\n"; 

# Send Question
  print $client_socket "What is your name?\n";		# Print to client
# Receive Answer
  my $name = "";   	
  $client_socket->recv($name, 1024);
  chomp($name);
# Decide Greeting to return to client
# If the name entered is Joe no password is required
  if ($name eq "Joe"){
    print "Name Entered: $name\nGreeting 1 sent\n";	# Output: name received
    $client_socket->send("Hello, Joe! How good of you to be here!\n");
    $client_socket->send("yes\n");					# terminate client while loop
  } 
# if the name entered is not Joe, the user needs to be validated with a password
  else {
    print "Name entered: $name\nGreeting 2 sent & wait for secret word\n";
    $client_socket->send("Hello, $name!\nWhat is the password?\n");
# Receive password from Client
    $client_socket->recv($guess,1024);
    print "Guess: $guess";				# Output: guess entered by client
    chomp($guess);

    $i = 0;								# Start at the first word in the array
    $correct = "maybe";					# Use as decision variable
# Use while loop to check the client secret word matches the words in the array
    while($correct eq "maybe")
    {
      if ($words[$i] eq $guess) 		# Exit if a match
      {
        $correct = "yes";				# The password received is in the array
		$client_socket->send("$correct");
		print "This is a match\n";		# Output: match
      }
      elsif ($i < 2) {$i = $i + 1;}		# Check the next word in the password array
      else{
        print "This is not a match\n";	# Ask client for secret word again
		print $client_socket "Wrong Try Again. What is the secret word?\n";
		$client_socket->recv($guess, 1024);
        print "New Guess: $guess";		# Output: new guess entered
		chomp($guess);					# Remove terminating character
		$i=0;
      } # else
    } # while
  }# else
} # while
close($socket);							# Close the socket
