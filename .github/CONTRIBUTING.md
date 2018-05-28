# Contributing to ArmorPowerShell

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to the community Armor PowerShell module, which are hosted on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table Of Contents

[Code of Conduct](#code-of-conduct)

[I don't want to read this whole thing, I just have a question!!!](#i-dont-want-to-read-this-whole-thing-i-just-have-a-question)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)

<!-- * [ArmorPowerShell Design Decisions](#design-decisions) -->

[How Can I Contribute?](#how-can-i-contribute)

* [Reporting Bugs](#reporting-bugs)
* [Suggesting Enhancements](#suggesting-enhancements)
* [Your First Code Contribution](#your-first-code-contribution)
* [Pull Requests](#pull-requests)

[Styleguides](#styleguides)

* [Git Commit Messages](#git-commit-messages)
* [PowerShell Styleguide](#powershell-styleguide)
<!-- * [Documentation Styleguide](#documentation-styleguide) -->

[Additional Notes](#additional-notes)

* [Issue and Pull Request Labels](#issue-and-pull-request-labels)

## Code of Conduct

This project and everyone participating in it is governed by the [ArmorPowerShell Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior on [**Gitter**][gitter].

## I don't want to read this whole thing I just have a question!!!

* [ArmorPowerShell FAQ][faq]

Feel free to open an issue for any questions; however, you may get a faster response via chat in [Gitter][gitter].

* Even though Gitter is a chat service, sometimes it takes several hours for community members to respond &mdash; please be patient!
* At present, the Gitter `Lobby` room used for everything: discussion, build notifications, et cetera.

## What should I know before I get started?

<!--
### Design Decisions

When we make a significant decision in how we maintain the project and what we can or cannot support, we will document it in the [design decisions page](design_decisions.md). If you have a question around how we do things, check to see if it is documented there. If it is *not* documented there, please feel free to ask on [Gitter][gitter] anytime.
-->

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for ArmorPowerShell. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template][bugs], the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

* **Check if you can reproduce the problem [in the latest version of ArmorPowerShell][psgallery]**.
* **Check the [FAQs on the forum][faq]** for a list of common questions and problems.
* **Perform a [cursory search][issue_search]** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). Create an issue using [the bug report template][bugs].

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible. For example, start by explaining which command exactly you used in the terminal. When listing steps, **don't just say what you did, but explain how you did it**.
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots** which show you following the described steps and clearly demonstrate the problem.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of ArmorPowerShell) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of ArmorPowerShell?** What's the most recent version in which the problem doesn't happen? You can download older versions of ArmorPowerShell from [the releases page](https://github.com/tlindsay42/ArmorPowerShell/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* **Which version of ArmorPowerShell are you using?**: You can get the exact version by running `Get-Module -Name 'Armor'` in PowerShell.
* **Which version of PowerShell are you using?**: You can get the exact version by running `Get-PSVersion` in PowerShell.
* **What's the name and version of the OS you're using**?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for ArmorPowerShell, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](ISSUE_TEMPLATE.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Check if you're using [the latest version of ArmorPowerShell][psgallery]**.
* **Perform a [cursory search](https://github.com/search?q=+is%3Aissue+user%3AArmorPowerShell)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots** which help you demonstrate the steps or point out the part of ArmorPowerShell which the suggestion is related to.
* **Explain why this enhancement would be useful** to most ArmorPowerShell users.

### Your First Code Contribution

Unsure where to begin contributing to ArmorPowerShell? You can start by looking through these `Type: Good First Issue` and `Type: Help Wanted` issues:

* [Good First Issues][good_first_issue]: beginner issues that should only require a few lines of code and a test or two.
* [Help Wanted Issues][help_wanted]: issues that should be a bit more involved than `Good First Issue` issues, but should follow existing templates.

### Pull Requests

* Fill in [the required template](PULL_REQUEST_TEMPLATE.md)
* Do not include issue numbers in the PR title
* Include screenshots and animated GIFs in your pull request whenever possible.
* Follow the [PowerShell](#powershell-styleguide) styleguides.
* End all files with a newline and trim all trailing whitespace
  * If you utilize [pre-commit] like I do
* Avoid platform-dependent code
* Place class properties in the following order:
  * Properties
  * Constructors
  * Methods

<!--
* Document new code based on the [Documentation Styleguide](#documentation-styleguide)
* Place requires in the following order:
-->

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line
* When only changing documentation, include `[ci skip]` in the commit title
* Consider starting the commit message with an applicable emoji:
  * :art: `:art:` when improving the format/structure of the code
  * :racehorse: `:racehorse:` when improving performance
  * :memo: `:memo:` when writing docs
  * :penguin: `:penguin:` when fixing something on Linux
  * :apple: `:apple:` when fixing something on macOS
  * :checkered_flag: `:checkered_flag:` when fixing something on Windows
  * :bug: `:bug:` when fixing a bug
  * :fire: `:fire:` when removing code or files
  * :green_heart: `:green_heart:` when fixing the CI build
  * :white_check_mark: `:white_check_mark:` when adding tests
  * :lock: `:lock:` when dealing with security
  * :arrow_up: `:arrow_up:` when upgrading dependencies
  * :arrow_down: `:arrow_down:` when downgrading dependencies
  * :shirt: `:shirt:` when removing linter warnings

### PowerShell Styleguide

All PowerShell must adhere to the style of this project, which follows [The PowerShell Best Practice and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle).

<!-->
### Documentation Styleguide
-->

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests. Most labels are used across all ArmorPowerShell repositories, but some are specific to `tlindsay42/ArmorPowerShell`.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in. For example, you might be interested in [open pull requests in `tlindsay42/ArmorPowerShell` which haven't been reviewed yet](https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+repo%3Atlindsay42%2FArmorPowerShell). To help you find issues and pull requests, each label is listed with search links for finding open items with that label in `tlindsay42/ArmorPowerShell` only and also across all ArmorPowerShell repositories. We  encourage you to read about [other search filters](https://help.github.com/articles/searching-issues/) which will help you write more focused queries.

The labels are grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Please open an issue on `tlindsay42/ArmorPowerShell` if you have suggestions for new labels.

[gitter]: https://gitter.im/ArmorPowerShell/Lobby
[faq]: http://armorpowershell.readthedocs.io/en/latest/usr_90_faq.html
[psgallery]: https://www.powershellgallery.com/packages/Armor
[issue_search]: https://github.com/tlindsay42/ArmorPowerShell/issues?utf8=%E2%9C%93&q=is%3Aissue
[bugs]: https://github.com/tlindsay42/ArmorPowerShell/blob/master/.github/ISSUE_TEMPLATE/bug_report.md
[good_first_issue]: https://github.com/tlindsay42/ArmorPowerShell/labels/Type%3A%20Good%20First%20Issue
[help_wanted]: https://github.com/tlindsay42/ArmorPowerShell/labels/Type%3A%20Help%20Wanted
