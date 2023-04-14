class EvaluationCriteria {
  final int numberOfWeeks,
      regular,
      midtermSupervisor,
      midtermPanel,
      endtermSupervisor,
      endtermPanel,
      report;
  final String id, course, semester, year;

  EvaluationCriteria({
    required this.id,
    required this.course,
    required this.semester,
    required this.year,
    required this.numberOfWeeks,
    required this.regular,
    required this.midtermSupervisor,
    required this.midtermPanel,
    required this.endtermSupervisor,
    required this.endtermPanel,
    required this.report,
  });
}

class Student {
  final String id, name, entryNumber, email;

  Student({
    required this.id,
    required this.name,
    required this.entryNumber,
    required this.email,
  });
}

class Faculty {
  final String id, name, email;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
  });
}

class Team {
  final int numberOfMembers;
  final String id;
  final List<Student> students;

  Team({
    required this.id,
    required this.numberOfMembers,
    required this.students,
  });
}

class Panel {
  final int numberOfEvaluators;
  final String id, course, year, semester;
  final List<Faculty> evaluators;

  Panel({
    required this.id,
    required this.numberOfEvaluators,
    required this.evaluators,
    required this.course,
    required this.year,
    required this.semester,
  });
}

class Evaluation {
  final int marks;
  final String id, remarks, type;
  final Student student;
  final Faculty faculty;

  Evaluation({
    required this.id,
    required this.marks,
    required this.remarks,
    required this.type,
    required this.student,
    required this.faculty,
  });
}

class AssignedPanel {
  late int numberOfAssignedTeams;
  late String id, course, term, semester, year;
  final Panel panel;

  late List<Team> assignedTeams;
  late List<Evaluation> evaluations;

  //TODO: remove null and make required
  final int? numberOfAssignedProjects;
  final List<String>? assignedProjectIds;

  AssignedPanel({
    required this.id,
    required this.course,
    required this.term,
    required this.semester,
    required this.year,
    required this.numberOfAssignedTeams,
    required this.panel,
    required this.assignedTeams,
    required this.evaluations,
    this.numberOfAssignedProjects,
    this.assignedProjectIds,
  });
}

class Project {
  final String id, title, description;

  Project({
    required this.id,
    required this.title,
    required this.description,
  });
}

class Offering {
  final String id, course, semester, year;
  final Faculty instructor;
  final Project project;

  Offering({
    required this.id,
    required this.instructor,
    required this.course,
    required this.semester,
    required this.year,
    required this.project,
  });
}

class Enrollment {
  final String id;
  final Offering offering;
  final Team team;
  final List<Evaluation> supervisorEvaluations;

  Enrollment({
    required this.id,
    required this.offering,
    required this.team,
    required this.supervisorEvaluations,
  });
}

class EnrollmentRequest {
  final String id, status;
  final Offering offering;
  String team_id;

  EnrollmentRequest({
    required this.id,
    required this.status,
    required this.offering,
    required this.team_id,
  });
}

class StudentEnrollmentRequest {
  final String id, status;
  final Offering offering;
  String team_id;

  StudentEnrollmentRequest({
    required this.id,
    required this.status,
    required this.offering,
    required this.team_id,
  });
}
