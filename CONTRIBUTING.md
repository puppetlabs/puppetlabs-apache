Checklist (and a short version for the impatient)
=================================================

  * Commits:

    - Make commits of logical units.

    - Check for unnecessary whitespace with "git diff --check" before
      committing.

    - Commit using Unix line endings (check the settings around "crlf" in
      git-config(1)).

    - Do not check in commented out code or unneeded files.

    - The first line of the commit message should be a short
      description (50 characters is the soft limit, excluding ticket
      number(s)), and should skip the full stop.

    - Associate the issue in the message. The first line should include
			the issue number in the form "(#XXXX) Rest of message".

    - The body should provide a meaningful commit message, which:

      - uses the imperative, present tense: "change", not "changed" or
        "changes".

      - includes motivation for the change, and contrasts its
        implementation with the previous behavior.

    - Make sure that you have tests for the bug you are fixing, or
      feature you are adding.

    - Make sure the test suites passe after your commit:
      `rake spec unit spec:system` More information on [testing](#Writing Tests) below

    - When introducing a new feature, make sure it is properly
      documented in the README.md

  * Submission:

    * Pre-requisites:

      - Sign the [Contributor License Agreement](https://cla.puppetlabs.com/)

      - Make sure you have a [GitHub account](https://github.com/join)

      - [Create a ticket](http://projects.puppetlabs.com/projects/modules/issues/new), or [watch the ticket](http://projects.puppetlabs.com/projects/modules/issues) you are patching for.

    * Preferred method:

      - Fork the repository on GitHub.

      - Push your changes to a topic branch in your fork of the
        repository. (the format ticket/1234-short_description_of_change is
        usually preferred for this project).

      - Submit a pull request to the repository in the puppetlabs
        organization.

The long version
================

  1.  Make separate commits for logically separate changes.

      Please break your commits down into logically consistent units
      which include new or changed tests relevent to the rest of the
      change.  The goal of doing this is to make the diff easier to
      read for whoever is reviewing your code.  In general, the easier
      your diff is to read, the more likely someone will be happy to
      review it and get it into the code base.

      If you are going to refactor a piece of code, please do so as a
      separate commit from your feature or bug fix changes.

      We also really appreciate changes that include tests to make
      sure the bug is not re-introduced, and that the feature is not
      accidentally broken.

      Describe the technical detail of the change(s).  If your
      description starts to get too long, that is a good sign that you
      probably need to split up your commit into more finely grained
      pieces.

      Commits which plainly describe the things which help
      reviewers check the patch and future developers understand the
      code are much more likely to be merged in with a minimum of
      bike-shedding or requested changes.  Ideally, the commit message
      would include information, and be in a form suitable for
      inclusion in the release notes for the version of Puppet that
      includes them.

      Please also check that you are not introducing any trailing
      whitespaces or other "whitespace errors".  You can do this by
      running "git diff --check" on your changes before you commit.

  2.  Sign the Contributor License Agreement

      Before we can accept your changes, we do need a signed Puppet
      Labs Contributor License Agreement (CLA).

      You can access the CLA via the [Contributor License Agreement link](https://cla.puppetlabs.com/)

      If you have any questions about the CLA, please feel free to
      contact Puppet Labs via email at cla-submissions@puppetlabs.com.

  3.  Sending your patches

      To submit your changes via a GitHub pull request, we _highly_
      recommend that you have them on a topic branch, instead of
      directly on "master" or one of the release.
      It makes things much easier to keep track of, especially if
      you decide to work on another thing before your first change
      is merged in.

      GitHub has some pretty good
      [general documentation](http://help.github.com/) on using
      their site.  They also have documentation on
      [creating pull requests](http://help.github.com/send-pull-requests/).

      In general, after pushing your topic branch up to your
      repository on GitHub, you can switch to the branch in the
      GitHub UI and click "Pull Request" towards the top of the page
      in order to open a pull request.


  4.  Update the related GitHub issue.

      If there is a GitHub issue associated with the change you
      submitted, then you should update the ticket to include the
      location of your branch, along with any other commentary you
			may wish to make.

Writing Tests
=============

# XXX The stuff we always say about how to get started with tests

If you have commit access to the repository
===========================================

Even if you have commit access to the repository, you'll still need to
go through the process above, and have someone else review and merge
in your changes.  The rule is that all changes must be reviewed by a
developer on the project (that didn't write the code) to ensure that
all changes go through a code review process.

Having someone other than the author of the topic branch recorded as
performing the merge is the record that they performed the code
review.


Additional Resources
====================

* [Getting additional help](http://projects.puppetlabs.com/projects/puppet/wiki/Getting_Help)

* [Writing tests](http://projects.puppetlabs.com/projects/puppet/wiki/Development_Writing_Tests)

* [Bug tracker (Redmine)](http://projects.puppetlabs.com/projects/modules)

* [Patchwork](https://patchwork.puppetlabs.com)

* [Contributor License Agreement](https://projects.puppetlabs.com/contributor_licenses/sign)

* [General GitHub documentation](http://help.github.com/)

* [GitHub pull request documentation](http://help.github.com/send-pull-requests/)

