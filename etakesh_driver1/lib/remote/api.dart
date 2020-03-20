import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../model/commandes.dart';
import '../model/eposition.dart';
import '../model/prestataires.dart';

//const BASE_URL = "http://api.e-takesh.com:26960/api";
const BASE_URL = "http://www.api.e-takesh.com:26525/api";
const GOOGLE_LOCATION_URL =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json";
const GOOGLE_API_KEY = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";
//AIzaSyDKqwhgY_Fe7L4pGnGEmbxQ9CeoQ-z_C5I
class API {
  static String TAG = "API";

  static Future findLocation(String input, String lang) {
    var url = GOOGLE_LOCATION_URL +
        "?input=" +
        input +
        "&language=" +
        lang +
        "&key=" +
        GOOGLE_API_KEY;
//    print("${TAG} findLocation url = ${url}");
    return http.get(url);
  }

  static Future findLocation1(String keyword, String lang, double lat, double lng) {
    var url = GOOGLE_LOCATION_URL +
        "?input=" +
        keyword +
        "&language=" +
        lang +
        "&key=" +
        GOOGLE_API_KEY +
        "&location=" +
        lat.toString() +
        "," +
        lng.toString() +
        "&radius=800";
    return http.get(url);
  }

  static Future executeUsersLogin(String email, String password) {
    var url = BASE_URL + "/Users/login";

    Map data = {
      'email': '${email}',
      'password': '${password}',
      'ttl': 315360000
    };
    //encode Map to JSON
    var body = json.encode(data);
//    print("${TAG} executeUsersLogin url = ${url} | body = ${body.toString()}");
    return http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future executeSaveContainers(String name, String token) {
    var url = BASE_URL + "/containers?access_token=${token}";

    Map data = {'name': '${name}'};
    //encode Map to JSON
    var body = json.encode(data);
//    print("${TAG} executeUsersLogin url = ${url} | body = ${body.toString()}");
    return http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future uploadPrestaImg(String container, File imgFile, String imgName, String token) {
    var url =
        BASE_URL + "/containers/${container}/upload?access_token=${token}";

    FormData formData = new FormData.from({
      "file": new UploadFileInfo(imgFile, "${imgName}")
    });
    Dio dio = new Dio();
    return dio.post(url, data: formData);
  }

  static String getProfileImgURL(String imageUrl, String token) {
    String url =
        imageUrl+"?access_token="+token;
    print("${TAG}:getProfileImgURL url = ${url}");
    return url;
  }

  static Future executeSetPrestaLogged(
      PrestatairesModel presta, String status, bool etat, String token) {
    var url = BASE_URL +
        "/prestataires/${presta.prestataireid}?access_token=${token}";
//    print("${TAG}:executeSetPrestaLogged url=${url}");

    Map data = {
      'cni': presta.cni,
      'date_creation': presta.date_creation,
      'date_naissance': presta.date_naissance,
      'email': presta.email,
      'nom': presta.nom,
      'pays': presta.pays,
      'prenom': presta.prenom,
      'status': status,
      'telephone': presta.telephone,
      'ville': presta.ville,
      'code': presta.code,
      'image': presta.image,
      'positionId': presta.positionId,
      'UserId': presta.UserId,
      'etat' : etat,
    };
    //encode Map to JSON
    var body = json.encode(data);
//    print("${TAG} executeSetPrestaLogged url = ${url} | body = ${body.toString()}");
    return http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future executeSetPrestaInfos(
      PrestatairesModel presta, String token) {
    var url = BASE_URL +
        "/prestataires/${presta.prestataireid}?access_token=${token}";
    print("${TAG}:executeSetPrestaInfos url=${url}");

    Map data = {
      'cni': presta.cni,
      'date_creation': presta.date_creation,
      'date_naissance': presta.date_naissance,
      'email': presta.email,
      'nom': presta.nom,
      'pays': presta.pays,
      'prenom': presta.prenom,
      'status': presta.status,
      'telephone': presta.telephone,
      'ville': presta.ville,
      'code': presta.code,
      'image': presta.image,
      'positionId': presta.positionId,
      'UserId': presta.UserId,
      'etat': presta.etat,
    };
    //encode Map to JSON
    var body = json.encode(data);
//    print("${TAG} executeSetPrestaLogged url = ${url} | body = ${body.toString()}");
    return http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future executeSetCmde(CommandesModel commande, String token) {
    print("iciiiiiiiiiiiiii");
    print(commande.is_refused);
    var url =
        BASE_URL + "/commandes/${commande.commandeid}?access_token=${token}";
    print("${TAG}:executeSetCmde url=${url}");

    Map data = {
      "code": commande.code,
      "date": commande.date,
      "date_debut": commande.date_debut,
      "date_fin": commande.date_fin,
      "montant": commande.montant,
      "status": commande.status,
      "distance_client_prestataire": commande.distance_client_prestataire,
      "duree_client_prestataire": commande.duree_client_prestataire,
      "date_acceptation": commande.date_acceptation,
      "date_prise_en_charge": commande.date_prise_en_charge,
      "position_prise_en_charge": commande.position_prise_en_charge,
      "position_destination": commande.position_destination,
      "rate_comment": commande.rate_comment,
      "rate_date": commande.rate_date,
      "rate_value": commande.rate_value,
      "is_created": commande.is_created,
      "is_accepted": commande.is_accepted,
      "is_refused": commande.is_refused,
      "is_terminated": commande.is_terminated,
      "clientId": commande.clientId,
      "prestationId": commande.prestationId,
      "prestataireId": commande.prestataireId,
      "position_priseId": commande.position_priseId,
      "position_destId": commande.position_destId
    };

    // on update les commande sur le serveur
    
    
    //encode Map to JSON
    var body = json.encode(data);
    print(
        "${TAG} executeSetPrestaLogged url = ${url} | body = ${body.toString()}");
    return http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }
// update la commande sur le serveur 

 static Future executeSetCmde1(CommandesModel commande, String token) {

print("update la commande refuser......");

    var url =
        BASE_URL + "/commandes/${commande.commandeid}?access_token=${token}";
    print("${TAG}:executeSetCmde url=${url}");

    Map data = {
      "code": commande.code,
      "date": commande.date,
      "date_debut": commande.date_debut,
      "date_fin": commande.date_fin,
      "montant": commande.montant,
      "status": commande.status,
      "distance_client_prestataire": commande.distance_client_prestataire,
      "duree_client_prestataire": commande.duree_client_prestataire,
      "date_acceptation": commande.date_acceptation,
      "date_prise_en_charge": commande.date_prise_en_charge,
      "position_prise_en_charge": commande.position_prise_en_charge,
      "position_destination": commande.position_destination,
      "rate_comment": commande.rate_comment,
      "rate_date": commande.rate_date,
      "rate_value": commande.rate_value,
      "is_created": commande.is_created,
      "is_accepted": commande.is_accepted,
      "is_refused": "true",
      "is_terminated": commande.is_terminated,
      "clientId": commande.clientId,
      "prestationId": commande.prestationId,
      "prestataireId": commande.prestataireId,
      "position_priseId": commande.position_priseId,
      "position_destId": commande.position_destId
    };

    // on update les commande sur le serveur
    
    
    //encode Map to JSON
    var body = json.encode(data);
    print(
        "${TAG} executeSetPrestaLogged url = ${url} | body = ${body.toString()}");
    return http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }



  

  static Future executeSetEPosition(EPositionModel eposition, String token) {
    var url =
        BASE_URL + "/positions/${eposition.positionid}?access_token=${token}";
//    print("${TAG}:executeSetEPosition url=${url}");

    Map data = {
      "latitude": eposition.latitude,
      "longitude": eposition.longitude,
      "libelle": eposition.libelle
    };

    //encode Map to JSON
    var body = json.encode(data);
//    print("${TAG} executeSetEPosition url = ${url} | body = ${body.toString()}");
    return http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future executeUsersLogout(String token) {
    var url = BASE_URL + "/Users/logout?access_token=${token}";

//    print("${TAG} executeUsersLogout url = ${url}");
    return http.post(url, headers: {"Content-Type": "application/json"});
  }

  static Future findOnePresta(int userId, String token) {
    var filter =
        "filter[where][UserId]=${userId}&filter[include]=position&filter[include][prestation]=service&filter[include][prestation]=vehicule";

    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/prestataires/findOne?${params}";

    print("${TAG} findClientByPrestaid url = ${url}");
    return http.get(url);
  }

  static Future findCompte(int prestataireId, String token) {
    var filter = "filter[where][prestataireId]=${prestataireId}";
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/comptes/findOne?${params}";

    print("${TAG} findCompte url = ${url}");
    return http.get(url);
  }

//  recupere les services
  static Future findAllServices(String token) {
    var url = BASE_URL + "/services?access_token=${token}";

//    print("${TAG} findClientByPrestaid url = ${url}");
    return http.get(url);
  }

//  recupere les services
  static Future findCmdeCreated(String token, int prestataireId) {
    var filter =
        "filter[include]=prestation&filter[include]=client&filter[include]=position_prise&filter[include]=position_dest&filter[where][prestataireId]=${prestataireId}&filter[where][is_created]=true&filter[where][is_accepted]=false&filter[where][is_refused]=false&filter[where][is_terminated]=false&filter[order]=date&filter[limit]=1";

//    print("${TAG}:findCmdeCreated filter=${filter}");
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/commandes?${params}";
    print("${TAG}:services url = ${url}");
    return http.get(url);
  }

//  recupere les services
  static Future findHistCmde(String token, int prestataireId) {
    var filter =
        "filter[include]=client&filter[include][prestation]=service&filter[where][prestataireId]=${prestataireId}&filter[where][is_refused]=false&filter[order]=date";

//    print("${TAG}:findCmdeCreated filter=${filter}");
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/commandes?${params}";
//    print("${TAG}:services url = ${url}");
    return http.get(url);
  }


static Future findHistCmdeTer(String token, int prestataireId) {
    var filter =
        "filter[include]=client&filter[include][prestation]=service&filter[where][prestataireId]=${prestataireId}&filter[where][status]=TERMINATED&filter[order]=date";

//    print("${TAG}:findCmdeCreated filter=${filter}");
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/commandes?${params}";
//    print("${TAG}:services url = ${url}");
    return http.get(url);
  }

//  recupere les services
  static Future findHistDepots(String token, int compteId) {
    var filter =
        "filter[where][compteId]=${compteId}";

//    print("${TAG}:findCmdeCreated filter=${filter}");
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/depots?${params}";
//    print("${TAG}:services url = ${url}");
    return http.get(url);
  }

//  recupere les services
  static Future findCmdeCreatedById(String token, int cmdeId) {
    var filter =
        "filter[include]=prestation&filter[include]=client&filter[include]=position_prise&filter[include]=position_dest&filter[where][is_created]=true&filter[where][is_accepted]=false&filter[where][is_refused]=false&filter[where][is_terminated]=false&filter[order]=date&filter[limit]=1";

//    print("${TAG}:findCmdeCreated filter=${filter}");
    String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/commandes/${cmdeId}?${params}";
//    print("${TAG}:findCmdeCreatedById url = ${url}");
    return http.get(url);
  }

   static Future findCmde(String token) {
   
//    print("${TAG}:findCmdeCreated filter=${filter}");
  //  String params = "${filter}&access_token=${token}";
    var url = BASE_URL + "/commandes/?access_token=${token}";
//    print("${TAG}:findCmdeCreatedById url = ${url}");
    return http.get(url);
  }

  static Future getClientById(int clientId, String token){

    var url = BASE_URL + "/clients/${clientId.toString()}?access_token=${token}";
    return http.get(url);
  }

  static Future findCmdeById(String token, int idCmde){
    var url = BASE_URL + "/commandes/${idCmde.toString()}?access_token=${token}";
    return http.get(url);
  }

  static Future findCmdeByIdVal(String token, int idCmde){
    var url = BASE_URL + "/commandes/${idCmde.toString()}?access_token=${token}";
    return http.get(url);
  }

}
