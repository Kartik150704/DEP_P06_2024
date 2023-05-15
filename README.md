# Capstone Management Web Portal

This is a web portal designed for capstone management, aimed at providing a centralized platform for faculty and students to efficiently manage and track capstone events. The application caters to three major stakeholders: Coordinators, Supervisors, and Students. Each stakeholder has specific functionalities and access levels within the portal. Additionally, there is an admin page that handles user management and academic semester dates.

## Features and Functionalities

### Students

- Login: Students can log in to the application using their credentials.
- Weekly Evaluations: Students can view and upload their marks for weekly evaluations, which are provided by their supervisors.
- Project Selection: Students can view the list of projects offered in the current semester and request enrollment for a specific project.

### Supervisors

- Login: Supervisors can log in to the application using their credentials.
- Student Management: Supervisors can view all the details of their enrolled students for the current semester.
- Evaluation Management: Supervisors can upload marks for weekly evaluations and edit them if necessary.
- Project Management: Supervisors can view the list of offered projects and offer a project for students to request. They can accept or reject project requests.
- Panel Management: Supervisors can view the panels they are assigned to and the teams assigned to those panels for evaluations. They can upload evaluations for the students assigned to their panels.

### Coordinators

- Login: Coordinators can log in to the application using their credentials.
- Enhanced Supervisor Functionalities: Coordinators have all the functionalities available to supervisors.
- Panel Creation and Assignment: Coordinators can create new panels and assign teams to those panels.
- Panel List: Coordinators can download the list of currently created panels.
- Evaluation Criteria: Coordinators can decide the evaluation criteria for the current semester, which will be applicable to all capstones.
- Event Management: Coordinators can release new events for the ongoing semester.
- Student Details: Coordinators can download the marks and details of all students in the current semester.

### Admin

- User Management: The admin has the ability to add users (both students and faculty) to the system.
- Academic Semester: The admin can mark the beginning and ending dates of an academic semester.

### Additional Features

- Search and Sort: The application provides search and sorting functionality in various sections, enhancing usability and convenience for all stakeholders.

## Technology Stack

The application is developed using the Flutter framework and the Dart programming language. The Firebase database is utilized for storing and retrieving data, ensuring a robust and efficient system.

## Getting Started

The following are the requirements for running our project:
- Flutter Version : 3.3.10
- Google Chrome

To run the Webapp:
- Open app directory in terminal and type ‘flutter pub get’ to get all dependencies
- Type ‘flutter run’ to run the website.

Note: The above requirements are not strict and the app may run on other versions also but this version is preferred.

You can also access the webapp using this link: http://172.26.1.231:80 \
Note that this a private IP address and can only be accessed from the university network.

## Conclusion

In conclusion, the Capstone Management Web Portal provides a comprehensive and user-friendly solution for managing capstone projects in an academic setting. With distinct functionalities tailored to the needs of coordinators, supervisors, students, and the admin, the portal streamlines the capstone management process and enhances collaboration among stakeholders.
