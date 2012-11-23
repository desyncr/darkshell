package functions;
sub parseuri {
    my ($url) = @_;

    # user:password@http://www.hostname.com/path/index.php
    my @params = split(/@/, $url);
    my $url = $params[1];           # http://www.hostname.com/path/index.php
    
    my $hostname;
    my @fulluri = split(/\//, $url);# http://www.hostname.com
    if ($url =~ m/https?:\/\//) {
        $hostname = $fulluri[2];    # www.hostname.com
    }else{
        $hostname = $fulluri[0];    # 
        $url = "http://$url";
    }

    my @userpass = split(/:/, $params[0]); # user:password
    my $user = $userpass[0];
    my $pass = $userpass[1];

    return {
        host => $hostname,
        user => $user,
        pass => $pass,
        url => $url,
    }
}
1;
