#!/usr/bin/perl -w
# Filename : jor_c2
# Joe O'Regan

# The Client socket receives a question from the Server socket
# "What is your name?"
# The Client sends a reply string to the Server with the name
# The Server then sends a reply to he Client
# depending on if the name matches the name stored the Server
# If the name is Joe the Server returns a greeting
# otherwise the Client must enter a password
# If the password is correct the Client receives a positive response
# otherwise it must guess the password until it guesses one of the
# answers in the array of passwords

use IO::Socket;

my $socket = new IO::Socket::INET (	# create a connecting socket
    PeerHost => 'localhost',
    PeerPort => '8000',
    Proto => 'tcp');
die "Cannot connect to the server $!\n" unless $socket;

print scalar <$socket>;				# Receive Question from Server
my $input=<STDIN>;					# Input answer
$socket->send($input); 				# Send answer to server
print scalar <$socket>; 			# Receive greeting from Sever

$response = scalar <$socket>; 		# exit OR ask for secret word
chomp($response);
# If the response isn't "yes" (for Randal) output the response
# The server asks for a secret word
if($response ne "yes"){print "R1: $response\n";}

while ($response ne "yes")			# While the response isn't yes (a match)
{
  $input=<STDIN>;					# Input the secret word
  $socket->send($input);			# Send the secret word
# Receive server response "yes" if a match, or ask for secret question again
  $socket->recv($response, 1024);	
  chomp($response);
  if($response ne "yes"){print "R2: $response\n";}	# Enter secret word again
  else {print "R2: $response, this is a match\n";}	# Response "yes" = match
}
close($socket);										# Close the socket
