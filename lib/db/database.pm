package database;
use debug::debug;
use DBI;

########################################################################
# Opens up a given SQLite database and set table name from where to read
#
# $db = Database::new('database','tablename');
#
sub new
{
    my ($class, $db, $table) = @_;

    my $self = {
        db  => $db,
        table => $table,
        dbi => DBI->connect("dbi:SQLite:" . $db . ".db"),
        debug => new debug('database', 1)
    };

    bless $self, $class;
    return $self;
}

########################################################################
# Sets table name from where to read
#
# $db->using('testtable');
sub using
{
    my ($self, $table) = @_;
    $self->{table} = $table;
}

########################################################################
# Out put debug info
sub debugStr
{
    my ($self) = @_;
    $self->{debug}->log($_[1]);
    return $_[1];
}

########################################################################
# Perform a select from the db.
#
# First param is a list of fields to retrieve.
# Second param is the where clause.
#
# $db->select(qw(id,name,surname), 'name!="pedro"')
sub select
{
    my ($self, $values, $where, $order, $limit) = @_;
    $values = join(",", $values);
    
    $where = "WHERE $where" unless $where != undef;
    $order = "ORDER BY $order" unless $order != undef;
    $limit = "LIMIT $limit" unless $limit == undef;
    
    return $self->{dbi}->selectall_arrayref(
        $self->debugStr("SELECT $values FROM $self->{table} $where $order $limit")
    );
    
}

########################################################################
# Count a rows
# 
#
#
sub count
{
    my ($self) = @_;
    return $self->{dbi}->selectall_arrayref(
        $self->debugStr("SELECT COUNT(*) FROM $self->{table}")
    );
}
########################################################################
# Insert a row into the database
# 
# first param is the list of values to insert
#
# $db->insert(qw(null,"pedro","paco"))
sub insert
{
    my ($self, %values) = @_;
    $self->{dbi}->do(
        $self->debugStr("INSERT INTO $self->{table} (`" . _kstr(%values) . "`) VALUES ('" . _vstr(%values) . "')")
    );
}

########################################################################
# Delete rows from the database given certain params
#
# $db->delete('name="pedro"');
#
sub delete
{
    my ($self, $where) = @_;
    $self->{dbi}->do(
        $self->debugStr("DELETE FROM $self->{table} WHERE $where")
    );
}

########################################################################
# Update rows from the database given certain params
#
# $db->update('name="pedro"');
#
sub update
{
    my ($self, $values, $where) = @_;
    $values = join("','", $values);
    $self->{dbi}->do(
        $self->debugStr("UPDATE $self->{table} SET $values WHERE $where")
    );
}

########################################################################
# Helper functions
sub _kstr
{
    my %k = @_;
    return join("`,`",keys(%k))
}

sub _vstr
{
    my %v = @_;
    return join("','",values(%v))
}

1;
