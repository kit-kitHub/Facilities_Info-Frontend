import 'package:flutter/material.dart';
import 'api_controller.dart';

class FacilityDetailScreen extends StatelessWidget {
  final TextEditingController _reviewCommentController = TextEditingController();
  final TextEditingController _reviewRatingController = TextEditingController();

  void _addReview(BuildContext context, int facilityId) async {
    final reviewData = {
      'facilityId': facilityId,
      'reviewComment': _reviewCommentController.text,
      'rating': int.parse(_reviewRatingController.text),
    };
    final response = await ApiController.addReview(reviewData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review added successfully')));
      Navigator.popAndPushNamed(context, '/detail', arguments: facilityId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add review')));
    }
  }

  void _toggleLike(BuildContext context, int facilityId, int reviewId) async {
    final response = await ApiController.toggleLike(reviewId);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Like status updated successfully')));
      Navigator.popAndPushNamed(context, '/detail', arguments: facilityId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update like status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int facilityId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Facility Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiController.getFacilityWithReviews(facilityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Facility not found'));
          } else {
            final facility = snapshot.data!;
            final reviews = facility['reviews'] as List<dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${facility['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Address: ${facility['address']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Description: ${facility['description']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Rating: ${facility['rating']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Type: ${facility['type']}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit', arguments: facilityId);
                      },
                      child: Text('Edit Facility Info'),
                    ),
                    SizedBox(height: 16),
                    Text('Reviews:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    reviews.isEmpty
                        ? Text('No reviews available.')
                        : Column(
                      children: reviews.map((review) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User: ${review['user']['username']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Rating: ${review['rating']}'),
                                Text('Comment: ${review['reviewComment']}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/editReview', arguments: review['id']);
                                      },
                                      child: Text('Edit'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await ApiController.deleteReview(review['id']);
                                        Navigator.popAndPushNamed(context, '/detail', arguments: facilityId);
                                      },
                                      child: Text('Delete'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        _toggleLike(context, facilityId, review['id']);
                                      },
                                      child: Text('Like (${review['likes']})'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Divider(), // 구분선 추가
                    Text('Add a Review:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _reviewCommentController,
                      decoration: InputDecoration(
                        labelText: 'Comment',
                      ),
                    ),
                    TextField(
                      controller: _reviewRatingController,
                      decoration: InputDecoration(
                        labelText: 'Rating',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _addReview(context, facilityId),
                      child: Text('Add Review'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
