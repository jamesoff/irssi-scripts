#<b> is bold
#<i> is inverse
#<u> is underscore
#<c>[foreground,background] is colour (untested)

Irssi::signal_add_first("event 311", filter_codes );
Irssi::signal_add_first("event 314", filter_codes );

sub filter_codes {
	my ($server, $blah) = @_;
	$blah =~ /.+:(.+)/;
	my $newblah = $1;
	$blah = $1;
	$newblah =~ s/\002/<b>/g;
	$newblah =~ s/\022/<i>/g;
	$newblah =~ s/\037/<u>/g;
	$newblah =~ s/\003([0-9]+)(,[0-9+])?/<c>\1,\2/g;

	if ($newblah ne $blah) {
		Irssi::print("Actual real name is: $newblah");
	}
}

