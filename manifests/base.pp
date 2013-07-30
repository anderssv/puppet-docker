
service { "puppet" :
  enable => true,
}

package { [ "subversion", "python-devel", "cronie" ]:
	ensure => installed
}

