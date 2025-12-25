import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utg91/core/di/injection_container.dart';
import 'package:utg91/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:utg91/features/collection/presentation/cubit/collection_state.dart';
import 'package:utg91/features/collection/presentation/widgets/mascot_card.dart';
import 'package:utg91/features/collection/presentation/widgets/unlock_celebration.dart';

/// Mascots Collection page - Tab 2
/// Displays all mascots (locked and unlocked)
/// Allows unlocking one mascot per day
class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CollectionCubit>()..loadCollection(),
      child: const _CollectionView(),
    );
  }
}

class _CollectionView extends StatelessWidget {
  const _CollectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CollectionCubit>().refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<CollectionCubit, CollectionState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            unlocked: (mascot, allMascots, unlockedMascots) {
              // Show unlock celebration
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => UnlockCelebration(mascot: mascot),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Initializing collection...'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (allMascots, unlockedMascots, canUnlock, nextUnlock) {
              return RefreshIndicator(
                onRefresh: () => context.read<CollectionCubit>().refresh(),
                child: CustomScrollView(
                  slivers: [
                    // Stats header
                    SliverToBoxAdapter(
                      child: _buildStatsHeader(
                        context,
                        unlockedMascots.length,
                        allMascots.length,
                        canUnlock,
                        nextUnlock,
                      ),
                    ),

                    // Mascot grid
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final mascot = allMascots[index];
                            final isUnlocked = mascot.unlockDate != null;

                            return MascotCard(
                              mascot: mascot,
                              isUnlocked: isUnlocked,
                              canUnlock: canUnlock && !isUnlocked,
                              onTap: () {
                                if (canUnlock && !isUnlocked) {
                                  _showUnlockDialog(context, mascot.id);
                                }
                              },
                            );
                          },
                          childCount: allMascots.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            unlocking: (mascotId) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Unlocking mascot...'),
                ],
              ),
            ),
            unlocked: (mascot, allMascots, unlockedMascots) => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading collection',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<CollectionCubit>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsHeader(
    BuildContext context,
    int unlockedCount,
    int totalCount,
    bool canUnlock,
    DateTime? nextUnlock,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Your Collection',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '$unlockedCount / $totalCount Mascots',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildUnlockStatus(context, canUnlock, nextUnlock),
        ],
      ),
    );
  }

  Widget _buildUnlockStatus(
    BuildContext context,
    bool canUnlock,
    DateTime? nextUnlock,
  ) {
    if (canUnlock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Tap a locked mascot to unlock!',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      );
    } else if (nextUnlock != null) {
      final hoursLeft = nextUnlock.difference(DateTime.now()).inHours;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Next unlock in ${hoursLeft}h',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _showUnlockDialog(BuildContext context, String mascotId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unlock Mascot?'),
        content: const Text(
          'You can only unlock one mascot per day. Are you sure you want to unlock this one?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CollectionCubit>().unlockMascot(mascotId);
            },
            child: const Text('Unlock'),
          ),
        ],
      ),
    );
  }
}
