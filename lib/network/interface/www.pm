package www;
use HTTP::Request::Common;
use HTTP::Response;
use HTTP::Cookies;
use LWP::UserAgent;

use lib::base;
use lib::logger;
our @ISA = qw(logger base);

sub new
{
	my ($class, $settings) = @_;

    my $self  = $class->SUPER::new($settings);
	my $child = {
		proxy 	=> $settings->{proxy}	    || 'socks://127.0.0.1:9050',
		proto 	=> $settings->{proto}       || 'http',

		timeout	=> $settings->{timeout}	    || 60,
		tries  	=> $settings->{tries}	    || 10,
		agent  	=> $settings->{agent}	    || 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',
        cookies => $settings->{cookies}     || 1,

        config  => $settings->{config}      || './config/',
        downloads=>$settings->{downloads}   || './downloads/',
        ua 		=> LWP::UserAgent->new,

        test    => $settings->{test}        || undef,

        debug       => $settings->{debug},
        verbosity   => $settings->{verbosity},
        version     => 2,
        revision    => 1,
	};
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    if (!$self->{test})
    {
        $self->{ua}->timeout($self->{timeout});
        $self->{ua}->agent($self->{agent});

        if ($self->{proxy}) {
            $self->{ua}->proxy($self->{proto} => $self->{proxy});
        }
        if ($self->{cookies}) {
            $self->{cookies} = HTTP::Cookies->new(
                                    file        => "$self->{config}/www.dat",
                                    autosave    => 1,
                                    ignore_discard => 1,
                                    );

            $self->{ua}->cookie_jar($self->{cookies});
        }
    }
    bless $self, $class;
    return $self;
}


sub get
{
    my ($self, $url) = @_;
    if (!$self->{test})
    {
        my $response = $self->{ua}->get($url);
        if ($response->is_success)
        {
            return $response->decoded_content;
        }else{
            return 0;
        }
    }else{
        open (HTML, "<$url");
        my @html = <HTML>;
        return join('', @html);
    }
}
sub post
{
	my ($self, $url, $post) = @_;
	$self->log("Post to: `$url`");
    $self->dump("Post stucture ", $post);
	my $response = $self->{ua}->post($url, $post );

	if ($response->is_success)
	{
        $self->log("Post was successfull");
        $self->log("Response was: " . $response->decoded_content);
		return $response->decoded_content;
	}else{
		$self->log("Error: " . $! );
		return 0;
	}
}
sub upload
{
    my ($self, $url, $post) = @_;
    return $self->post($url,
                    Content_Type => 'multipart/form-data',
                    Content => $post
                    );
}
sub download
{
    my ($self, $url, $dest) = @_;
    $self->log("Downloading '$url' to '$self->{downloads}/$dest'");
    if (!$self->{test})
    {
        my $response = 0;
        eval { $response = $self->{ua}->mirror($url, "$self->{downloads}/$dest") };
        if ($response && $response->is_success)
        {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}

1;
