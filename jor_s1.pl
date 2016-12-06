#!/usr/bin/perl -w
# Filename: jor_s1
# Joe O'Regan

# Client receives a question from the Server
# "What is your name?"
# The Client sends a reply string to the Server
# The Server then sends a reply to he Client
# depending on if the name matches the name stored 
# the Server

use strict;								# All variables declared with my function before use
use IO::Socket; 

$| = 1; 								# Auto-flush on socket

my $socket = new IO::Socket::INET (		# Create a new listening socket
    LocalHost => '0.0.0.0',				# Host to listen
    LocalPort => '8000',				# Port to listen on (must be same as client)
    Proto => 'tcp',						# TCP - connection-oriented protocol
    Listen => 5,						# Max number of sockets to put on hold
    Reuse => 1);						# Socket can be reused
die "Cannot create socket $!\n" unless $socket;	# Error message if socket can't be created
print "Server waiting for client connection on port 7777\n";
 
while(1)
{ 
# New socket ($client_socket) is returned Messages sent by client can now be read from here
  my $client = $socket->accept(); 					# Waiting for a new client connection
# get information about a newly connected client
  my $client_address = $client->peerhost(); 		# Client address
  my $client_port = $client->peerport();			# Client port number
  print "New connection from $client_address:$client_port\n";   

# Scalar Variables
  my $question = "What is your name?\n";
  my $name = "";
  my $greeting1 = "Hello, Joe! How good of you to be here!\n";
  my $greeting2 = "Hello, ";
# Send Question
  print $client "$question\n";			# Send scalar variable to client (format 1)
  print "Question sent: \n$question";	# Socket output
# Receive Answer     			
  $client->recv($name, 1024);			# read up to 1024 characters from connected client
  chomp($name);							# chomp response received for if else statement
    print "Name Recieved: $name\n";		# Socket output
  $greeting2 .= "$name!\n";				# Concatenate strings

  if ($name eq "Joe"){					# Decide & Send Greeting
    $client->send($greeting1);			# Send scalar variable to client (format 2)
      print "Greeting 1 sent \n$greeting1\n";	# Socket output 1
  } 
  else {
    $client->send($greeting2);
      print "Greeting 2 sent: \n$greeting2\n";	# Socket output 2
  }
} 
$socket->close();								# Close Socket
