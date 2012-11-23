package curl;
use Data::Dumper;
use lib::debug::debug;

sub new
{
    my ($class, $settings) = @_;

    my $self = {
        proxy   => @$settings{proxy}        || '',  # 127.0.0.1:1234
        proto   => (@$settings{proto})? "--" . @$settings{proto} : '',  # socks5-hostname

        timeout => @$settings{timeout}  || 60,
        tries   => @$settings{tries}    || 10,  # this should be a  global conf
        user    => @$settings{agent}    || 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',

        debug   => new debug('curl.log', @$settings{verbosity}),
        test    => @$settings{test},

        version => 2,
        revision => 1,
    };

    bless $self, $class;
    return $self
}

sub get
{
    my ($self, $url, $html) = @_;
    for my $try (0..$self->{tries})
    {
        $self->{debug}->log("Getting: $url ($try)");
        $html = `curl -L --user-agent "$self->{user}" $self->{proto} $self->{proxy} $url`;
        last if !$?;
    }
    return (!$?) ? $html : $?;
}

sub download
{
    my ($self, $url, $dest) = @_;
    for my $try (0..$self->{tries})
    {
        $self->{debug}->log("Downloading '$url' to '$dest' ($try)");
        #$self->{debug}->log("`curl --output '$dest' --user-agent '$self->{user}' $self->{proto} $self->{proxy} -C - --retry $self->{tries} $url`");
        `curl --output "$dest" --user-agent "$self->{user}" $self->{proto} $self->{proxy} -C - --retry $self->{tries} $url`;
        last if !$?;
    }
    return $?;
}
1;
