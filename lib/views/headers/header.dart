import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/navigation_service.dart';

import '../../dependencyInjection.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                locator<NavigationService>().navigateTo(AboutRoute);
              },
              child: Text(
                'About',
                style: GoogleFonts.ptSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
