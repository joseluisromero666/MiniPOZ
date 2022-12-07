const firebase_client = require("firebase");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { dialogflow } = require("actions-on-google");
const Firestore = require("@google-cloud/firestore");

admin.initializeApp();

var config = {
  apiKey: "AIzaSyBpnpy12R_IoznlxrdmvTp4HD6-uvo7fhc",
  authDomain: "pos-flutter-26725.firebaseapp.com",
  projectId: "pos-flutter-26725",
  storageBucket: "pos-flutter-26725.appspot.com",
  messagingSenderId: "544703752699",
  appId: "1:544703752699:web:84b25f215a40cb0dd1035e",
  measurementId: "G-RC8D6MJGXE",
};

firebase_client.initializeApp(config);

exports.createEmployee = functions.firestore
  .document("/employees/{documentId}")
  .onCreate((snap, context) => {
    const employee = snap.data();
    functions.logger.log("empleado", context.params.documentId, employee);
    try {
      admin
        .auth()
        .createUser({
          uid: context.params.documentId,
          email: employee.email,
          emailVerified: false,
          phoneNumber: employee.phone,
          password: employee.document,
          displayName: employee.name,
          photoURL: employee.urlImg,
          disabled: false,
        })
        .then((userRecord) => {
          console.log("Successfully created new user:", userRecord.uid);
          firebase_client.auth().sendPasswordResetEmail(employee.email);
        })
        .catch((err) => {
          console.log("Error creating new user:", err);
        });
    } catch (e) {
      console.error(e);
    }
  });

exports.updateEmployee = functions.firestore
  .document("/employees/{documentId}")
  .onUpdate((snap, context) => {
    const newEmployee = snap.after.data();
    const oldEmployee = snap.before.data();
    functions.logger.log("User", context.params.documentId, newEmployee);
    try {
      admin
        .auth()
        .updateUser(context.params.documentId, {
          email: newEmployee.email,
          displayName: newEmployee.name,
          photoURL: newEmployee.urlImg,
        })
        .then((userRecord) =>
          functions.logger.log("Succesfully updated:", userRecord.uid)
        )
        .catch((e) => console.error(e));
    } catch (error) {
      console.error(error);
    }
  });

exports.deleteEmployee = functions.firestore
  .document("/employees/{documentId}")
  .onDelete((snap, context) => {
    const employee = snap.data();
    functions.logger.log(
      "empleado ha eliminar",
      context.params.documentId,
      employee
    );
    try {
      admin
        .auth()
        .deleteUser(context.params.documentId)
        .then(() => console.log("Successfully deleted user"))
        .catch((err) => console.log("Error deleting new user:", err));
    } catch (e) {
      console.error(e);
    }
  });

exports.createMensage = functions.firestore
  .document("/ComprasHechas/{documentId}")
  .onCreate((snap, context) => {
    const Venta = snap.data();
    try {
      admin.messaging().sendMulticast({
        tokens: [Venta.token],
        notification: {
          title: "Venta Realizada!",
          body:
            "Cliente " +
            Venta.nombre +
            ", Medio de pago " +
            Venta.medioPago +
            ", Valor Total " +
            Venta.valorTotal +
            ".",
        },
      });
    } catch (e) {
      console.error(e);
    }
  });

exports.createMensageEmployees = functions.firestore
  .document("/employees/{documentId}")
  .onCreate((snap, context) => {
    const employee = snap.data();
    try {
      admin.messaging().sendMulticast({
        tokens: [employee.token],
        notification: {
          title: "Creacion Realizada!",
          body: "Email " + employee.email + ", Role " + employee.role + ".",
        },
      });
    } catch (e) {
      console.error(e);
    }
  });

exports.createMensageProducts = functions.firestore
  .document("/products/{documentId}")
  .onCreate((snap, context) => {
    const products = snap.data();
    try {
      admin.messaging().sendMulticast({
        tokens: [products.token],
        notification: {
          title: "Creacion Realizada!",
          body:
            "Producto " +
            products.name +
            ", Categoria " +
            products.tax +
            ", Valor " +
            products.value +
            ".",
        },
      });
    } catch (e) {
      console.error(e);
    }
  });

const app = dialogflow({ debug: true });

app.intent("Agregar Etiqueta", (conv, { nombre, color }) => {
  if (nombre === undefined || color === undefined) {
    conv.add(`<speak>El nombre y color no pueden estar vacíos</speak>`);
  } else if (nombre === "" || color === "") {
    conv.add(`<speak>El nombre y color no pueden estar vacíos</speak>`);
  } else {
    admin
      .firestore()
      .collection("tags")
      .add({ name: nombre, color: color })
      .then((userRecord) => {
        console.log("Successfully created new tag:", userRecord.uid);
      })
      .catch((err) => {
        console.log("Error creating new tag:", err);
      });

    conv.add(
      `<speak>Se agregó la etiqueta ${nombre} de color ${color}</speak>`
    );
  }
});

exports.dialogflowFirebaseFulfillment = functions.https.onRequest(app);
