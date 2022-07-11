package openBSDApi::Model::Data;

use strict;
use warnings;
use experimental qw(signatures);
use Mojo::JSON qw(decode_json encode_json);
use POSIX qw(strftime);

sub new ($class, $config) {
    my $self = {app_config => $config};
    bless $self, $class;
    return $self;
}

sub _read_json_file ($self, $json_file) {
    open(my $in, '<', $json_file) or $self->app->log->error("Unable to open file $json_file : $!");
    my $json_text = do { local $/ = undef; <$in>; };
    close($in) or $self->app->log->error("Unable to close file : $!");

    my $config_data = decode_json($json_text);
    return $config_data;
}

sub _write_json_file ($self, $json_file, $data) {
    my $now = strftime "%Y%m%d%H%M%S", localtime();
    rename($json_file, $json_file.$now);
    my $rt = 1;
    open(my $in, '>', $json_file) or $rt = 0;
    print $in $data;
    close($in) or $rt = 0;
    return $rt;
}

sub get_openbsd_data ($self) {
    my $data_in_json = $self->_read_json_file($self->{app_config}->{openbsdconfig});
    return $data_in_json;
}

sub save_data ($self, $data) {
     my $rt = $self->_write_json_file($self->{app_config}->{openbsdconfig}, encode_json($data));
     return $rt;
}

1;
