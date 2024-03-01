import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;

  final pages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(.0),
          child: Image.asset(
            'images/logo.png', // Replace with your logo image path
            height: 50,
            width: 50,
          ),
        ),
        title: Text(
          "CareerHub Connect",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 30,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.chat_bubble,
                    color: Colors.white,
                    size: 30,
                  )
                : const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                    size: 30,
                  )
                : const Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  )
                : const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 4;
              });
            },
            icon: pageIndex == 4
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  )
                : const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: jobList.length,
        itemBuilder: (context, index) {
          return JobCard(job: jobList[index]);
        },
      ),
    );
  }
}

class Job {
  final String title;
  final String location;
  final String jobType;
  final String salary;

  Job({
    required this.title,
    required this.location,
    required this.jobType,
    required this.salary,
  });
}

class JobCard extends StatefulWidget {
  final Job job;

  JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBooked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Set the elevation of the card
      child: InkWell(
        // Wrap the card in InkWell for tapping effect
        onTap: () {
          // Handle tap on the job card
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width:
                      double.infinity, // Make the container take the full width
                  height: 250.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'images/company.jpeg'), // Set the background image
                      fit: BoxFit.cover, // Cover the entire container
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isBooked = !isBooked;
                    });
                  },
                  child: IconButton(
                    icon: FaIcon(
                      isBooked
                        ? FontAwesomeIcons.solidBookmark
                        : FontAwesomeIcons.bookmark,
                      color: isBooked
                        ? const Color.fromARGB(255, 94, 90, 90)
                        : const Color.fromARGB(255, 127, 95, 95),
                    ),
                    onPressed: () {
                      // Handle save icon click
                      print('Bookmark Clicked');//for testing
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      // ignore: deprecated_member_use
                      const FaIcon(FontAwesomeIcons.mapMarkerAlt, size: 14.0),
                      const SizedBox(width: 4.0),
                      Text(widget.job.location),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text('Job Type: ${widget.job.jobType}'),
                  const SizedBox(height: 4.0),
                  Text('Salary: ${widget.job.salary}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Job> jobList = [
  Job(
    title: 'Software Engineer',
    location: 'San Francisco, CA',
    jobType: 'Full-time',
    salary: '\$120,000 - \$150,000',
  ),
  Job(
    title: 'UX/UI Designer',
    location: 'New York, NY',
    jobType: 'Contract',
    salary: '\$80,000 - \$100,000',
  ),
  Job(
    title: 'Cleaner',
    location: 'Shillong',
    jobType: 'Part-time',
    salary: 'Rs.3000- Rs.4500',
  ),
  // Add more job data as needed
];

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 2",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 3",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 4",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 5",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
