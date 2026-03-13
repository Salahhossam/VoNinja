import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/event_model.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';
import 'event_cubit/event_cubit.dart';
import 'leader_board_quiz_page.dart';


import 'package:loading_overlay/loading_overlay.dart';



class LeaderboardQuizInstructionsPage extends StatefulWidget {
  final AppEvent event;

  const LeaderboardQuizInstructionsPage({
    super.key,
    required this.event,
  });

  @override
  State<LeaderboardQuizInstructionsPage> createState() =>
      _LeaderboardQuizInstructionsPageState();
}

class _LeaderboardQuizInstructionsPageState
    extends State<LeaderboardQuizInstructionsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cubit = EventCubit.get(context);
    final up = cubit.userEventsProgress?[widget.event.id];
    final hasStarted = up != null && up.status == 'in_progress';

    return Scaffold(
      backgroundColor: AppColors.lightColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
        title: Text(
          widget.event.title,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: Image.asset(
          'assets/img/ninja_gif.gif',
          height: 100,
          width: 100,
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if ((widget.event.imageUrl ?? '').isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.event.imageUrl ?? '',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.event.instructions.map(
                        (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.secondColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() => isLoading = true);

                  final uid = await CashHelper.getData(key: 'uid');
                  await cubit.joinLeaderboardQuizEvent(uid, widget.event);
                  await cubit.fetchUserEventsProgress(uid);

                  setState(() => isLoading = false);

                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaderboardQuizPage(event: widget.event),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:Text(
                  hasStarted
                      ? S.of(context).continueEvent
                      : S.of(context).startEvent,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}