class Student {
  final int id;
  final String name, entryNumber;

  Student({
    required this.id,
    required this.name,
    required this.entryNumber,
  });
}

class Faculty {
  final int id;
  final String name, email;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
  });
}

class Team {
  final int id, projectId, numberOfMembers;
  final List<Student> students;

  Team({
    required this.id,
    required this.projectId,
    required this.numberOfMembers,
    required this.students,
  });
}

class Evaluation {
  final Team team;
  final Faculty evaluator;
  final List<SingularEvaluation> evaluation;

  Evaluation({
    required this.team,
    required this.evaluator,
    required this.evaluation,
  });
}

class SingularEvaluation {
  final int studentId, marks;
  final String remarks;

  SingularEvaluation({
    required this.studentId,
    required this.marks,
    required this.remarks,
  });
}

class Panel {
  final int id, numberOfEvaluators;
  final List<Faculty> evaluators;

  Panel({
    required this.id,
    required this.numberOfEvaluators,
    required this.evaluators,
  });
}

class AssignedPanel {
  final int numberOfAssignedTeams;
  final String course, type, semester, year;
  final Panel panel;
  final List<Team> assignedTeams;
  final List<Evaluation> evaluations;

  AssignedPanel({
    required this.course,
    required this.type,
    required this.semester,
    required this.year,
    required this.numberOfAssignedTeams,
    required this.panel,
    required this.assignedTeams,
    required this.evaluations,
  });
}

final studentGlobal = [
  Student(
    id: 1,
    name: 'Ojassvi Kumar',
    entryNumber: '2020csb1187',
  ),
  Student(
    id: 2,
    name: 'Aman Kumar',
    entryNumber: '2020csb1153',
  ),
  Student(
    id: 3,
    name: 'Rishabh Jain',
    entryNumber: '2020csb1198',
  ),
  Student(
    id: 4,
    name: 'Aman Adatia',
    entryNumber: '2020csb1154',
  ),
];

final facultyGlobal = [
  Faculty(
    id: 1,
    name: 'Shweta Jain',
    email: 'sj@iitrpr.ac.in',
  ),
  Faculty(
    id: 2,
    name: 'Shashi Shekhar Jha',
    email: 'ssj@iitrpr.ac.in',
  ),
  Faculty(
    id: 3,
    name: 'Apurva Mudgal',
    email: 'am@iitrpr.ac.in',
  ),
  Faculty(
    id: 4,
    name: 'Anil Shukla',
    email: 'as@iitrpr.ac.in',
  ),
  Faculty(
    id: 5,
    name: 'Nitin Aucluck',
    email: 'na@iitrpr.ac.in',
  ),
  Faculty(
    id: 6,
    name: 'Shirshendu Das',
    email: 'sd@iitrpr.ac.in',
  ),
];

final teamGlobal = [
  Team(
    id: 1,
    projectId: 1,
    numberOfMembers: 2,
    students: [
      studentGlobal[0],
      studentGlobal[1],
    ],
  ),
  Team(
    id: 2,
    projectId: 2,
    numberOfMembers: 2,
    students: [
      studentGlobal[2],
      studentGlobal[3],
    ],
  ),
];

final panelGlobal = [
  Panel(
    id: 1,
    numberOfEvaluators: 2,
    evaluators: [
      facultyGlobal[0],
      facultyGlobal[1],
    ],
  ),
  Panel(
    id: 2,
    numberOfEvaluators: 2,
    evaluators: [
      facultyGlobal[2],
      facultyGlobal[3],
    ],
  ),
  Panel(
    id: 3,
    numberOfEvaluators: 2,
    evaluators: [
      facultyGlobal[4],
      facultyGlobal[5],
    ],
  ),
];

final assignedPanelGlobl = [
  AssignedPanel(
    course: 'CP301',
    type: 'MidTerm',
    semester: '2',
    year: '2023',
    numberOfAssignedTeams: 2,
    panel: panelGlobal[0],
    assignedTeams: [
      teamGlobal[0],
      teamGlobal[1],
    ],
    evaluations: [
      Evaluation(
        evaluation: [
          SingularEvaluation(
            studentId: teamGlobal[0].students[0].id,
            marks: 5,
            remarks: 'Good work',
          ),
          SingularEvaluation(
            studentId: teamGlobal[0].students[1].id,
            marks: 4,
            remarks: 'Ok work',
          ),
        ],
        evaluator: facultyGlobal[0],
        team: teamGlobal[0],
      ),
      Evaluation(
        evaluation: [
          SingularEvaluation(
            studentId: teamGlobal[0].students[0].id,
            marks: 5,
            remarks: 'Good work',
          ),
          SingularEvaluation(
            studentId: teamGlobal[0].students[1].id,
            marks: 4,
            remarks: 'Ok work',
          ),
        ],
        evaluator: facultyGlobal[1],
        team: teamGlobal[0],
      ),
    ],
  ),
  AssignedPanel(
    course: 'CP301',
    type: 'MidTerm',
    semester: '2',
    year: '2023',
    numberOfAssignedTeams: 1,
    panel: panelGlobal[1],
    assignedTeams: [
      teamGlobal[1],
    ],
    evaluations: [
      Evaluation(
        evaluation: [
          SingularEvaluation(
            studentId: teamGlobal[1].students[0].id,
            marks: 5,
            remarks: 'Good work',
          ),
          SingularEvaluation(
            studentId: teamGlobal[1].students[1].id,
            marks: 4,
            remarks: 'Ok work',
          ),
        ],
        evaluator: facultyGlobal[2],
        team: teamGlobal[0],
      ),
      Evaluation(
        evaluation: [
          SingularEvaluation(
            studentId: teamGlobal[1].students[0].id,
            marks: 5,
            remarks: 'Good work',
          ),
          SingularEvaluation(
            studentId: teamGlobal[1].students[1].id,
            marks: 4,
            remarks: 'Ok work',
          ),
        ],
        evaluator: facultyGlobal[3],
        team: teamGlobal[0],
      ),
    ],
  ),
  AssignedPanel(
    course: 'CP301',
    type: 'MidTerm',
    semester: '2',
    year: '2023',
    numberOfAssignedTeams: 0,
    panel: panelGlobal[2],
    assignedTeams: [],
    evaluations: [],
  ),
];
