use Orbital::Transfer::Common::Setup;
package Orbital::CLI::Command::Launch::RepoInfo;
# ABSTRACT: Dump repository info

use Modern::Perl;
use Mu;
use CLI::Osprey;
use Clone qw(clone);
use Try::Tiny;
use Path::Tiny;

lazy finder => method() {
	eval "require Orbital::Payload::Meta::GitGot::RepoFinder"; ## no critic: 'ProhibitStringyEval'
	my $finder = Orbital::Payload::Meta::GitGot::RepoFinder->new;
};

method run() {
	## no critic: 'ProhibitStringyEval'
	eval q|
		use DDP; p $self->get_info( $self->repo_path );
	|;
}

has _info_cache => (
	is => 'ro',
	default => sub { +{} },
);

method get_info( $path ) {
	my $info;
	return $self->_info_cache->{$path} if exists $self->_info_cache->{$path};

	require Orbital::Launch::Repo;
	my $repo = Orbital::Launch::Repo->new(
		directory => $path,
		config => undef,
		platform => undef,
	);

	Moo::Role->apply_roles_to_object( $repo, 'Orbital::Launch::Repo::Role::DistZilla');
	Moo::Role->apply_roles_to_object( $repo, 'Orbital::Launch::Repo::Role::CpanfileGit');
	Moo::Role->apply_roles_to_object( $repo, 'Orbital::Launch::Repo::Role::DevopsYaml');

	$info->{path} = path($path);
	try {
		$info->{devops} = $repo->devops_data;
	} catch {
	};
	my $deps = clone($repo->cpanfile_git_data);

	for my $name ( keys %{ $deps } ) {
		my $github = Orbital::Payload::Service::GitHub::Repo->new(
			uri => $deps->{$name}{git},
		);

		my $dep_path = $self->finder->find_path( $github );

		$info->{deps}{$name} = $self->get_info(
			$dep_path,
		);
	}

	my ($gitgot_for_path) = grep { $_->repo_path eq $info->{path} } @{ $self->finder->gitgot->data };
	$info->{gitgot}{tags} = $gitgot_for_path->repo_tags;

	$self->_info_cache->{$path} = $info;
}

## no critic: 'ProhibitStringyEval'
eval q|
with qw(Orbital::CLI::Command::Role::Option::RepoPath);
|;

1;