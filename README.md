[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/James-DBA-Anderson/SQL-Server-And-Continuous-Integration/master?grs=github&t=black)

***SQL Server & Continuous Integration***

How do you know your database change won’t affect something you haven’t thought of?

Database objects can have many dependant objects in the database and in the application. Keeping track of these dependencies can be difficult, especially if the database is used by multiple applications or services.

The first step is to have a project for the database and get it into source control.

Source control is the single source of truth that all deployments should be kept in sync with. Source controlling the database also acts as the foundation for automation of:

Builds
Tests
Coverage Reports
This automation is key to the Continuous Integration methodology. After every commit, builds and tests will run in the background and only alert if there is a problem. Builds test the deployment of the change and tests check that everything affected still works. Coverage reports indicate any gaps in the testing suite.

The tools I use to make this possible with SQL Server are:

Redgate’s ReadyRoll plugin for Visual Studio to build migration scripts
GitLab for source control and project management
tSQLt for unit tests
SQL Cover for unit test coverage reports
By the end of this session I hope you will see how a CI approach to database development can remove the unknowns from deploying database changes.