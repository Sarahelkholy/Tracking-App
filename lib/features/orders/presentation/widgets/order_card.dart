import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/cached_network_image_wrapper.dart';
import '../../../../core/utils/app_colors.dart';
import '../mangers/home_cubit.dart';

class OrderCard extends StatelessWidget {
  final String storeName;
  final String storeAddress;
  final String? storeImage;

  final String userName;
  final String userAddress;
  final String? userImage;

  final String price;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderCard({
    super.key,
    required this.storeName,
    required this.storeAddress,
    this.storeImage,
    required this.userName,
    required this.userAddress,
    this.userImage,
    required this.price,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Flower order",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),

          const SizedBox(height: 16),

          Text("Pickup address", style: TextStyle(color: Colors.grey.shade600)),

          const SizedBox(height: 8),

          AddressTile(
            image: storeImage,
            title: storeName,
            subtitle: storeAddress,
          ),

          const SizedBox(height: 16),

          Text("User address", style: TextStyle(color: Colors.grey.shade600)),

          const SizedBox(height: 8),

          AddressTile(image: userImage, title: userName, subtitle: userAddress),

          const SizedBox(height: 20),

          SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink,
                    side: const BorderSide(color: Colors.pink),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  child: const Text("Reject"),
                ),

                const SizedBox(width: 12),

                FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.selectedOrder != current.selectedOrder,
                    builder: (BuildContext context, HomeState state) {
                      if (state.selectedOrder.isLoading) {
                        return const CircularProgressIndicator(
                          color: AppColors.baseWhite,
                          strokeWidth: 2,
                        );
                      }
                      return const Text("Accept");
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? image;

  const AddressTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: image != null && image!.isNotEmpty
                ? CachedNetworkImageWrapper(
                    imagePath: image!,
                    width: 48,
                    height: 48,
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
