#!/usr/bin/perl -w					# Indicates this is a Perl program
# Filename : jor_c1
# Joe O'Regan

# Client receives a question from the Server
# "What is your name?"
# The Client sends a reply string to the Server
# The Server then sends a reply to he Client
# depending on if the name matches the name stored 
# the Server

use strict;			# Variables must be declared with my (For compiling, also helps spot errors)
use IO::Socket;		# Module built on socket with functions & variables

# create a connecting socket
my $socket = new IO::Socket::INET (
    PeerHost => 'localhost',			# (PeerAddr) The remote host address
    PeerPort => '7777',					# Port (must be same as Server)
    Proto => 'tcp');					# Uses TCP protocol
die "Cannot connect to the server $!\n" unless $socket; # Error message

# Receive Question
my $question = <$socket>;				# Receive message from server (format 1)
print "Question received: \n$question";	# print the received question

# Input & Send Answer
my $answer=<STDIN>;						# Get answer input from keyboard
$socket->send($answer);					# Send: send answer to server
 
# Receive Servers Response (up to 1024 characters)
my $response = "";
$socket->recv($response, 1024);			# Receive message from server (format 2)
print "Greeting received: \n$response";	# print the received greeting
 
close($socket);							# Close the socket
