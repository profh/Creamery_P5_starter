67-272: Creamery Project (Spring 2020)
===

This is the solution set (in progress) for the Creamery Project in the spring of 2020 for 67-272.

This particular version is in Rails 5.2.7 because of some callback bugs in the current 6.0 version of Rails.

All models, controllers, and services have 100% test coverage.

Create and populate the database
---

The development database can be created and populated with a large number of realistic, but still fictitious, data by running the command `rake db:populate` on the command line of the main directory.  This will take a few minutes, but will give you:

1. Two admins, Alex and Mark; each has a username that is lowercase of their first name and a password of 'secret'.

2. Seven stores in the Pittsburgh area and a manager that is assigned to each.  Manager usernames are their first and last names downcases and concatenated with a '.' and all passwords are secret.

3. 140 regular employees; all have username of 'user' and some number concatenated as well as a password of 'secret'. 

4. Each employee has 1-3 assignments, and each employee's current assignment has 15-50 past shifts and 1-6 upcoming shifts.  Each past shift has one job assigned to it.


Additional notes
---
As you think through your information architecture, here are a couple of things to keep in mind:

- Employees need to quickly find upcoming shifts they are scheduled to work.
- Employees need to be able to see their most recent pay statement (or payroll).
- If an employee logs in and has a shift scheduled that day that is pending, some type of large button to "clock in" should appear; if the shift has started, but not over, then a similar "clock out" button should appear.
- A manager's most important task is to add upcoming shifts to employees assigned to the store over the next seven days. (That is, today and the next seven days)
- Consequently, seeing a list of upcoming shifts already scheduled for the particular store for today and the next seven days would also be very helpful to managers.
- Managers also need to easily fill out reports on the various jobs performed after each employee's shift is finished.  This is often seen by managers as a nuisance, so if you can make the process easy, it would be greatly appreciated by the managers.
- Administrators need a way to easily calculate the payrolls for a particular store over a particular time period (e.g, past two weeks, past month, etc.)
- Administrators have other needs that you should reflect on further.