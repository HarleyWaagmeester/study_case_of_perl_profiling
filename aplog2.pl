#!/usr/bin/perl

# This program reads from standard input.
# It is designed to parse the /var/log/apache2/access.log file
# and produce an html formated output on stdout.
# You need read permission for the /var/log/apache2/access.log file.
# This program and all it's supporting files are distributed under
# the GNU GPL.


sub purple
{
    print "<font color=\"#ff00ff\">@_</font><br>\n";
}
sub brown
{
    print "<font color=\"#a52a2a\">@_</font><br>\n";
}
sub green
{
    print "<font color=\"#2e8b57\">@_</font><br>\n";
}
sub black
{
    print "<font color=\"#000000\">@_</font><br>\n";
}

my @rawips;
my $purpose = shift @ARGV;
print "created by:  ",$0, " ", $purpose, "<br>\n";
print "performing command: $purpose<br>\n";

while (<>) {
    $entry++;
    /^(\S+) (\S+) (\S+) (\[.+\]) (\"[^\"]+\") (\S+) (\S+) (\"[^\"]+\") (\"[^\"]+\")/;

    push @rawips,$1;

    if ($purpose eq "logview") {
        black "______Access num.$entry";

        purple $1;
        green $4;
        brown $5;
        black $6;
        black $7;
        black $8;
        black $9;

        black "______End of access num.$entry";
        print "<br>\n";
    }    
}

if ($purpose eq "candidate_000") {
    ip_sorter_candidate_000();
}
if ($purpose eq "candidate_001") {
    ip_sorter_candidate_001();
}
if ($purpose eq "candidate_002") {
    ip_sorter_candidate_002();
}
if ($purpose eq "ping") {
    ping();
}

exit;


#////////////////////////////////////////////////////////////
#////////// ip sorters ////////////////////////////////
#///////////////////////////////////////////////////////////

# This will sort by the hash values only.
sub ip_sorter_candidate_000
{
    @ips =  sort map { s/(\d+)/$1/eg ; $_ } @rawips;

    my %seen;

    foreach my $ip (@ips) {
	if (! $seen{$ip}) {
	    push @unique, $ip;
	    $seen{$ip} = 1; # i.e. the hash value associated with $key is set to 1.
	}else {
	    $seen{$ip} = ++$seen{$ip};
	}
    }

    # print "key sort:\n";
    # foreach (sort { ($seen{$a} <=> $seen{$b}) || ($a <=> $b) } keys %seen) {
    # 	print "$_ => $seen{$_}<br>\n";
    # }

    print "/////////////////////////////////////////////////////////////\n";
    print "value then key sort:<br>\n";
    foreach (sort { $seen{$b} <=> $seen{$a} || $a <=> $b } keys %seen)
	#    foreach (sort { ($seen{$a} cmp $seen{$b}) || ($a cmp $b) } keys %seen)
    {
	print "$_: $seen{$_}<br>\n";
    }
}



sub ip_sorter_candidate_001 {
    @ips =  sort map { s/(\d+)/$1/eg ; $_ } @rawips;
    @out =
	map  substr($_, 4) =>
	sort
	map  pack('C4' =>
		  /(\d+)\.(\d+)\.(\d+)\.(\d+)/)
	. $_ => @ips;
    foreach (@out) {
	print "$_<br>\n";
    }
}

sub ip_sorter_candidate_002 {
    @ips =  sort map { s/(\d+)/$1/eg ; $_ } @rawips;
    my @sorted = map { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map {      my ($x,$y)=(0,$_);
	       $x=$_ + $x * 256 for split(/\./, $y);
	       [$y,$x]}
    @ips;
    print join("<br>\n",@sorted), "<br>\n";
#    foreach (@sorted) {
#	print "$_<br>\n";
#    }
}

sub ip_sorter_candidate_003 {
    @ips =  sort map { s/(\d+)/$1/eg ; $_ } @rawips;
    print join("<br>\n",@sorted), "<br>\n";
}


sub ping {
    
    @ips =  sort map { s/(\d+)/$1/eg ; $_ } @rawips;

    print join ('<br>\n',@ips), "<br>\n";
}






#Project ap-log.pl END ------------------------------



