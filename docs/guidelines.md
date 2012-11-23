On Coding Standards and Code Reviews
====================================

I've been asked to prepare some guidelines on coding standards and code reviews in general, across a number of languages used at work, not just Perl. After doing a bit of basic research, I've cobbled together the notes below. To gain some feedback, I'm posting an early draft here.

Note that language-specific coding standards are not covered here; these will be covered in separate coding standards documents, one for each language.

Most of the coding guidelines below were not invented by me, but derived from hopefully well-respected sources; see the Coding Standards References section below for details.

## General Guidelines

These are some general attributes you should strive for in your code. Remember that code maintainability is paramount.

 - Robustness, Efficiency, Maintainability.
 - Scalability, Abstraction, Encapsulation.
 - Uniformity in the right dimension, creativity in dimensions that matter.
 - Correctness, simplicity and clarity come first. Avoid unnecessary cleverness.
 - If you must rely on cleverness, encapsulate and comment it.
 - [DRY (Don't repeat yourself).](http://en.wikipedia.org/wiki/Don't_repeat_yourself)
 - Prefer to find errors at compile time rather than run time.
 - Establish a rational error handling policy and follow it strictly.
 - Throw exceptions instead of returning special values or setting flags.
 - Know when and how to code for concurrency.
 - Use a single-step automated build system.
 - Practice releasing regularly.
 - Plan to evolve the code over time.
 - Invest in code reviews.
 - Consider the code from the perspective of: usability, simplicity, declarativeness, expressiveness, regularity, learnability, extensibility, customizability, testability, supportability, portability, efficiency, scalability, maintainability, interoperability, robustness, type safety, thread-safety/reentrancy, exception-safety, security. Resolve any conflicts between perspectives based on requirements.
 - Agree upon a coherent layout style and automate it.
 - When in doubt, or when the choice is arbitrary, follow the common standard practice or idiom.
 - Don't optimize prematurely. Benchmark before you optimize. Comment why you are optimizing.
 - Don't pessimize prematurely.
 - Don't reinvent the wheel. If there is a library method that implements the functionality you need, use it.
 - Be const correct.
 - Adopt a policy of zero tolerance for warnings and errors. This principally means compiling cleanly at high warning levels, but is broader than that; for example, tools such as checked STL implementations, static code analysers (e.g. Perl::Critic, FxCop), dynamic code analysers (e.g. valgrind, Purify), unit tests (e.g. Test::More, NUnit), code that emits spurious warnings/errors in customer log files, and so on. Third party files may be exempt from this policy.
 - Use a revision control system.
 - Write the test cases before the code. When refactoring old code (with no unit tests), write unit tests before you refactor.
 - Add new test cases before you start debugging.
 - Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.

## Design

 - Coupling and Cohesion. Systems should be designed as a set of cohesive modules as loosely coupled as is reasonably feasible.
 - Testability. Systems should be designed so that components can be easily tested in isolation.
 - Data hiding. Minimize the exposure of implementation details.
 - Minimize the use of global data.
 - Interfaces matter. Once an interface becomes widely used, changing it becomes practically impossible (just about anything else can be fixed in a later release).
 - Design the module's interface first.
 - Design interfaces that are: consistent; easy to use correctly; hard to use incorrectly; easy to read, maintain and extend; clearly documented; appropriate to your audience. Be sufficient, not complete; it is easier to add a new feature than to remove a mis-feature.

## Maintainability/Supportability

 - Follow the de facto standard set by the code you are editing. Or change the entire source file to the new standard.
 - Remove unused code.
 - Assert liberally. Asserts should be used to document the constraints for a piece of code.
 - Log liberally. Strive to log enough information to trouble-shoot a customer problem without the need to attach a debugger.
 - The result of every file operation or API call or external command must be checked, and unexpected results handled.
 - Any unexpected result from a file operation or API call or external command should be logged.
 - Avoid magic numbers. Note that 0 and 1 are ok and are not considered magical.
 - Limit and explicitly comment case "fall throughs".
 - Avoid side effects. e.g. inside macros.

## Layout

Layout rules will vary between organisations. These sort of arbitrary code layout rules should be enforced by a tool (e.g. Perl::Tidy).

 - Use spaces not TABs.
 - Three character indent (four is more common; get agreement and enforce with a tool).
 - No long lines. Limit the line length to a maximum of 120 characters.
 - No trailing whitespace on any line.
 - Put brace on a new line.
 - Single space around keywords, e.g. if (.
 - Single space around binary operators, e.g. 42 + 69
 - Single space after comment marker, e.g. "// fred" not "//fred", "# fred" not "#fred"
 - No space around unary operators, e.g. ++i
 - No space before parens with functions/macros, e.g. fred( 42, 69 )
 - Single space after parens with functions/macros, e.g. fred( 42, 69 )
 - Single space after comma with functions/macros, e.g. fred( 42, 69 )
 - Layout lists with one item per line; this makes it easier to see changes in version control.
 - One declaration per line.
 - Function calls with more than two arguments should have the arguments aligned vertically.
 - Avoid big-arse functions and methods. Ditto for large classes and large files.
 - Avoid deep nesting.
 - Always use braces with if statements, while loops, etc. This makes changes shorter and clearer in version control.

## Naming

 - Use descriptive, explanatory, consistent and regular names.
 - Favour readability over brevity.
 - Avoid identifiers that conflict with keywords.
 - Short names for short scopes, longer names for longer scopes.
 - Avoid ambiguous words in names (e.g. Don't abbreviate "Number" to "No"; "Num" is a better choice).

## Encapsulation

 - Minimize the scope of variables, pragmas, etc..
 - Minimize the visibility of variables.
 - Don't overload variables with multiple meanings.

## Comments

 - Prefer to make the code obvious.
 - Don't belabour the obvious.
 - Generally, comments should describe what and why, not how.
 - Remove commented-out code, unless it helps to understand the code, then clearly mark it as such.
 - Update comments when you change code.
 - Separate user versus maintainer documentation.
 - Include a comment block on every non-trivial method describing its purpose.
 - Major components should have a larger comment block describing their purpose, rationale, etc.
 - There should be a comment on any code that is likely to look wrong or confusing to the next person reading the code.
 - Every non-local named entity (function, variable, class, macro, struct, ...) should be commented.

## Portability

 - Assume file names are case insensitive in that you cannot, in general, have two different files called fred and Fred.
 - Source code file names should be all lower case.
 - File names should only contain A-Z, a-z, 0-9, ".", "_", "-".
 - Strive to structure code around "capabilities" rather than specific platforms. For example, "if HAVE_SHADOW_PASSWORDS" rather than "if SOLARIS_8". And define the capabilities in one place only (e.g. config.h).
 - Organise the code so that machine dependent and machine independent code reside in separate files.
 - Abstract hardware and external interfaces in a module and have all other code call that module and not call the hardware/external interface directly.
 - As far as possible, write code to a widely supported portable standard (e.g. ANSI C, POSIX, ...) and only use machine specific facilities when absolutely necessary.
 - Recognize and avoid non-portable constructs. For example, strive to avoid relying on ASCII character set, big v little-endian, 32-bit v 64-bit ints, pointer to int conversion, sign extension, and so on.

## User Interfaces

 - All command line tools should provide a usage option to explain the usage of the command. Always include at least one example in the usage description. You must at least support the -h option for help and optionally may support --help.
 - Provide appropriate, clear feedback to the user of the progress of any long running operations and make them easy to cancel and safely rerunnable.

## GUI User Interfaces

 - Have clear objectives and guiding principles.
 - Define personas; design to satisfy their goals.
 - Adopt the user's perspective. Involve users in design. Perform usability tests. Give the user control. Make it configurable. Design iteratively.
 - GUIs should reflect the user mental model, not the implementation model. Hide implementation details.
 - Communicate actions to user. Provide feedback. Anticipate errors. Forgive errors. Offer warnings.
 - Cater for both novice and expert. For novice: easy-to-learn, discoverable, tips, help. For expert: efficiency, flexibility, shortcuts, customizability. Optimize for intermediates.
 - Keep interfaces simple, natural, consistent, attractive. Try to limit to seven simultaneous concepts.
 - Use real-world metaphors.
 - Ask forgiveness, not permission. Make all actions reversible.
 - Eliminate excise.
 - Be polite; remember what the user entered last time.
 - Avoid dialog boxes as much as possible; don't use them to report normalcy.
 - Provide "wizards" for complex procedural tasks.

## Security

 - Define security requirements as part of product requirements.
 - Conduct security reviews (creating a threat model) if warranted by requirements.
 - Know where to look for exploit notices and stay up-to-date.
 - Use least privilege; only run with superuser privilege when you need to.
 - When using fixed length buffers, ensure that any possible overflow is handled.
 - Handle all errors (e.g. don't ignore error returns). Fail securely.
 - Define secure defaults.
 - Know how to call external components safely.
 - Know how to handle insecure environment (e.g. environment variables, umask, inherited file descriptors, symbolic links, temporary files, child processes, ...).
 - Validate insecure external data (e.g. input to program, parameters to an exported API).
 - Beware of race conditions.
 - Avoid canonical file paths and URLs.
 - Use a security code review checklist.
 - Use security code analysis tools.
 - Minimize your attack surface.
 - Know how to defend against common known attacks.
 - Defend in depth.
 - Don't tell the attacker anything.
 - Don't mix code and data.
 - Don't depend on security through obscurity.
 - Heed compiler warnings.
 - Architect and design for security policies. Keep it as simple as possible.
 - Default deny. Base access decisions on permission not exclusion, by default deny access.
 - Use effective QA: fuzz testing, penetration testing, source code audits.
 - Adopt a secure coding standard.

## Internationalization (i18n) and Localization (L10n)

These domains warrant their own section. However, both these domains can be incredibly challenging. :-) For now, this is just a stub section.

 - Define the product internationalization and localization goals.

## Code Reviews

The two principal types of code review are: formal and lightweight.

Formal code reviews require significant planning, training and resources; they are carried out in multiple phases by multiple participants playing various roles. The most well-known formal code review method is the [Fagan inspection](http://en.wikipedia.org/wiki/Fagan_inspection).

Lightweight code reviews, having less overhead than formal ones, are cheaper to conduct. The [Best Kept Secrets of Peer Code Review](http://www.smartbear.com/codecollab-code-review-book.php) book argues that lightweight code reviews are cheaper to perform than formal ones and can be just as effective. The four most common types of lightweight code review are:

 - Over-the-shoulder.
 - Email pass-around.
 - Pair programming.
 - Tool-assisted.

## Lightweight Code Review Tips

Cited in [Best Kept Secrets of Peer Code Review](http://www.smartbear.com/codecollab-code-review-book.php), the conclusions drawn from a lightweight code review case study at Cisco are:

 - LOC under review should be less than 200 and not exceed 400. Larger LOCs tend to overwhelm reviewers.
 - Total review time should be less than 60 minutes and not exceed 90. Defect detection rates plummet after 90 minutes.
 - Inspection rates less than 300 LOC/hour result in best defect detection. Expect to miss a significant percentage of defects if faster than 500 LOC/hour.
 - Expect defect rates of around 15 per hour.
 - Authors who prepare for the review with annotations and explanations have far fewer defects than those that do not.

## The Seven Deadly Sins of Software Reviews

According to Karl Wiegers, the [Seven Deadly Sins of Software Reviews](http://www.processimpact.com/articles/revu_sins.html) are:

 - Participants don't understand the review process.
 - Reviewers critique the producer, not the product.
 - Reviews are not planned.
 - Review meetings drift into problem-solving.
 - Reviewers are not prepared.
 - The wrong people participate.
 - Reviewers focus on style, not substance.

## Miscellaneous Code Review Tips

 - Before the code review, push the code review through a tool that checks for straightforward layout and stylistic issues; this avoids wasting time on trivia during the review.
 - Most of the code review work should be done before the code review meeting.
 - The code review should be in writing.
 - Have at least two code reviewers.

## Tool-assisted Code Review

Guido van Rossum's first project at Google was Mondrian, a code review tool. Though he was unable to open source that work, he has since released the open source [Rietveld](http://googleappengine.blogspot.com/2008/05/open-source-app-rietveld-code-review.html) code review tool. An exhaustive list of code review tools can be found at [Survey of Code Review Tools](http://www.laatuk.com/tools/review_tools.html).

In addition to tools that streamline the administrative side of the code review process, source code analysis tools can further be useful during code reviews. These tools fall into three broad categories:

 - Code Formatters. e.g. Perl::Tidy.
 - Static Code Analysers. e.g. Perl::Critic.
 - Dynamic Code Analysers. e.g. valgrind.
