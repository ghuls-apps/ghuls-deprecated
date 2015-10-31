# Changelog
## Version 1
### Version 1.3.0
* New -d --debug option to show a progress bar.

### Version 1.2.0
* Fix require_relative statement for utilities.rb, so it now actually works outside of the project root.
* Better error handling for authentication error (ProgramFOX)
* You can now get organization data for people other than yourself. It now checks if the user is a contributor to the org repos, rather than a collaborator, which was causing issues. (#19.)

### Version 1.1.0
* Organizations that the -g user contributed to are now supported.
* Better error-type-thing reporting.
* Catches Octokit::Unauthorized errors and returns false when initializing the client.
* Fix user_exists? error catching minor syntax bug.


### Version 1.0.2
* Actually fix load path stuff again.

### Version 1.0.1
* Fix load path stuff.

### Version 1.0.0
* Initial release
