import 'package:image_stack/image_stack.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CustomColors {
  static const Color kBackground = Color(0xFFDBE9F6);
  static const Color kBlue = Color(0xFF604ED1);
  static const Color kTeal = Color(0XFF3ED7EF);
}

class TaskDetailView extends StatefulWidget {
  const TaskDetailView({super.key});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: CustomColors.kBackground,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/user1.jpg'),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 30),
            const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.black, size: 15),
                SizedBox(width: 3),
                Text("Mar"),
                Spacer(),
                Text("April",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Spacer(),
                Text("May"),
                SizedBox(width: 3),
                Icon(Icons.arrow_forward, color: Colors.black, size: 15)
              ],
            ),
            const SizedBox(height: 40),
            const CustomRadioButtons(),
            const SizedBox(height: 40),
            const Text("Ongoing",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (ongoingTaskList[index].isBooked) {
                    return SizedBox(
                      height: 130,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                ongoingTaskList[index].startingTime,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(ongoingTaskList[index].endingTime,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: CustomColors.kBlue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Mobile App Design",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Mike and Anita",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w100),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ImageStack(
                                        imageList: const [
                                          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                                        ],
                                        imageSource: ImageSource.Network,
                                        totalCount: 2,
                                        imageRadius: 35,
                                        imageCount: 3,
                                        imageBorderWidth: 0,
                                      ),
                                      const Text("Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 40,
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Text(
                            ongoingTaskList[index].startingTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(Icons.circle,
                                color: Colors.red, size: 14),
                          ),
                          Expanded(
                              child: Container(
                            height: 1,
                            color: Colors.red,
                          ))
                        ],
                      ),
                    );
                  }
                },
                separatorBuilder: (ctx, index) => const SizedBox(height: 10),
                itemCount: ongoingTaskList.length)
          ])),
    );
  }
}

class OngoingTasks {
  String startingTime;
  String endingTime;
  bool isBooked;
  OngoingTasks({
    required this.startingTime,
    required this.endingTime,
    required this.isBooked,
  });
}

List<OngoingTasks> ongoingTaskList = [
  OngoingTasks(startingTime: '08 AM', endingTime: '09 AM', isBooked: true),
  OngoingTasks(startingTime: '10 AM', endingTime: '10 AM', isBooked: false),
  OngoingTasks(startingTime: '11 AM', endingTime: '12 PM', isBooked: true),
  OngoingTasks(startingTime: '01 PM', endingTime: '02 PM', isBooked: true),
];

class CustomRadioButtons extends StatefulWidget {
  const CustomRadioButtons({super.key});

  @override
  State<CustomRadioButtons> createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  int groupValue = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeumorphicRadio(
            groupValue: groupValue,
            style: const NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.stadium()),
            value: 1,
            onChanged: (value) {
              setState(() {
                groupValue = value!;
              });
            },
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              width: 55,
              decoration: BoxDecoration(
                  color: groupValue == 1 ? CustomColors.kBlue : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("12",
                      style: TextStyle(
                          color: groupValue == 1 ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Wed",
                      style: TextStyle(
                          color: groupValue == 1 ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          NeumorphicRadio(
            groupValue: groupValue,
            style: const NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.stadium()),
            value: 2,
            onChanged: (value) {
              setState(() {
                groupValue = value!;
              });
            },
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              width: 55,
              decoration: BoxDecoration(
                  color: groupValue == 2 ? CustomColors.kBlue : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("13",
                      style: TextStyle(
                          color: groupValue == 2 ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Thurs",
                      style: TextStyle(
                          color: groupValue == 2 ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          NeumorphicRadio(
            groupValue: groupValue,
            style: const NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.stadium()),
            value: 3,
            onChanged: (value) {
              setState(() {
                groupValue = value!;
              });
            },
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              width: 55,
              decoration: BoxDecoration(
                  color: groupValue == 3 ? CustomColors.kBlue : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("14",
                      style: TextStyle(
                          color: groupValue == 3 ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Fri",
                      style: TextStyle(
                          color: groupValue == 3 ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          NeumorphicRadio(
            groupValue: groupValue,
            style: const NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.stadium()),
            value: 4,
            onChanged: (value) {
              setState(() {
                groupValue = value!;
              });
            },
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              width: 55,
              decoration: BoxDecoration(
                  color: groupValue == 4 ? CustomColors.kBlue : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("15",
                      style: TextStyle(
                          color: groupValue == 4 ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Sat",
                      style: TextStyle(
                          color: groupValue == 4 ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
