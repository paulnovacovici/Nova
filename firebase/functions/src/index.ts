import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
// const db = admin.firestore();

import * as sgMail from "@sendgrid/mail";

const API_KEY = functions.config().sendgrid.key;
const CHECK_IN_TEMPLATE_ID = functions.config().sendgrid.check_in_template;
sgMail.setApiKey(API_KEY);

export const newCheckIn = functions.firestore
  .document("{env}/{envDoc}/check-in/{docId}")
  .onCreate(async (change, context) => {
    const checkIn = change.data() || {};

    // Email Content
    const msg = {
      to: checkIn.brand_email,
      from: "novacovici.consulting@gmail.com",
      templateId: CHECK_IN_TEMPLATE_ID,
      dynamicTemplateData: {
        subject: `New Check-in for ${checkIn.store}`,
        images: checkIn.images,
        needs: checkIn.needs,
        store: checkIn.store,
        manager: checkIn.manager,
      },
    };

    // Send it
    return sgMail.send(msg).catch((error) => {
      functions.logger.error(error.toString());
    });
  });
