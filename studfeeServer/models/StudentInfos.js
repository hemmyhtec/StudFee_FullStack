// require('dotenv').config()
const mongoose = require("mongoose");
const Schema = mongoose.Schema
// const express = require('express');
// const app = express();

// const connUri = process.env.MONGODB_URI
const studentInfo = new Schema({
    admissionNumber: { type: String },
    name: { type: String },
    department: { type: String },
    yearOfAdmin: { type: String }
})

module.exports = mongoose.model('StudentInfos', studentInfo);
// const StudentInfo = mongoose.model('StudentInfos', studentInfo)
// module.exports = StudentInfo
    // const StudentInfo = mongoose.model("StudentInfos", {
    //     admissionNumber: { type: String },
    //     name: { type: String },
    //     department: { type: String },
    //     yearOfAdmin: { type: String }
    // });
    

    
    // (async () => {
    //     try {
    //        mongoose.connect(connUri, {
    //         useNewUrlParser: true,
    //         useUnifiedTopology: true,
    //       });
    //       console.log('DB Connected');
      
    //       const docs =[
    //         { admissionNumber: "1810203016", name: "AHMAD ZURKANNAINI", department: "Computer Science", yearOfAdmin: "2018/2019"},
    //         { admissionNumber: "1810203098", name: "BAWA HAMISU", department: "Computer Science", yearOfAdmin: "2018/2019"},
    //         { admissionNumber: "1910203002", name: "ABDULRAUF KABIRU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203003", name: "ABRAHAM  ELISHA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203004", name: "ABUBAKAR ABUBAKAR", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203007", name: "ABUBAKAR MUSTAPHA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203008", name: "ABUBAKAR  NAFIU SODANGI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203009", name: "ABUBAKAR UMMUSALMA USMAN", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203010", name: "ALHASSAN ABDULHADI GALADIMA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203012", name: "ALIU MUHAMMED", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203013", name: "ALIYU ABUBAKAR", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203014", name: "ANTHONY FAITH", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203015", name: "BABANGIDA MUBARAK", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203016", name: "BALOGUN YUSUFF ISOLA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203019", name: "DAUDA  DEBORAH PENI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203020", name: "ELAIGWU OJONUGWA DANIEL", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203024", name: "HUSSAINI AMINA YAKUBU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203025", name: "IBRAHIM KHADEEJA BABANGIDA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203026", name: "IBRAHIM BILAL", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203028", name: "ISMAIL AWAL NUHU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203029", name: "JOSHUA YUSUF SHIRDOTUNA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203030", name: "KABIRU MASUDU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203031", name: "SHEHU KABIRU SARKI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203032", name: "KHALID ABDULWAHAB", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203034", name: "IBRAHIM ADAMU  MAIYAKI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203036", name: "MUHAMMAD HARUNA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203037", name: "MUHAMMAD  MUNIR", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203039", name: "MUHAMMED SAMAILA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203040", name: "MUSA YUSUF", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203041", name: "NUREIN TOHEEB", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203042", name: "OLABINTAN IBRAHEEM", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203043", name: "OLUSEGUN ELIJAH  OLUWAFEMI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203045", name: "SAIDU HASSAN", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203046", name: "IDRIS SALMANU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203050", name: "ABUBAKAR SURAIYAH", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203051", name: "TANKO ALIYU YUSUF", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203053", name: "IBRAHIM USAMA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203054", name: "USMAN ABDULHAFIZ", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203055", name: "USMAN ZULKIFILU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203056", name: "YUSUF ABDULBASIT MORAI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203059", name: "OBINECHE PETER CHIKWADO", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203060", name: "BAMIDELE YUSUF AYOBAMI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203061", name: "BELLO SHAMSUDDEEN", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203063", name: "FAIZA ABUBAKAR KAOJE", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203064", name: "ADAMU MESHACH AUTA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203065", name: "DANLADI HAJARA HUSSAINI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203067", name: "ABDULMUMIN HAFSAT TONDIH", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203068", name: "MUHAMMAD DAUDA MAKUKU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203069", name: "OKWUMUO  CHUKWUNWENDU INNOCENT", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203070", name: "OMOKANYE KOLAWOLE JAMES", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203071", name: "RABIU SODIQ ISHOLA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203074", name: "SALIHU RILWANU", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203075", name: "YAKUBU ISAAC", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203077", name: "SULEIMAN ISAH SHABANDA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203078", name: "ADAMU MUSTAFA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203082", name: "SEGHOSIMHE THEOPHILUS", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203083", name: "BALA SULEMAN SHANTALI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203085", name: "SARGWAK CHRISTOPHER", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203087", name: "ABDULRAZAK ABDULROQIB", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203089", name: "OKUNLOLA JAMIU OPEYEMI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203090", name: "ALIYU ABDULLAHI AHMAD", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203092", name: "YOHANNA JAPHETH ZIMRO", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203094", name: "MUSA AROME HOSENI", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203097", name: "ASHIRU FARUQ", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "1910203099", name: "BRAIMAH MICHAEL ILUGBEKHA", department: "Computer Science", yearOfAdmin: "2019/2020"},
    //         { admissionNumber: "2020203002", name: "YAHAYA NURADEEN TONDI", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203003", name: "WUYA CHRISTIANA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203004", name: "MUHAMMAD ABUBAKAR DANTANI", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203005", name: "KOLAWOLE EMMANUEL ASIYANBI", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203006", name: "ISAH KHALID DAYA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203007", name: "JIBO GAMBO", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203010", name: "ABUBAKAR MUSTAPHA KOKO", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203011", name: "ABDULLAHI MUDASSIR RABIU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203013", name: "YUSHAU ISAH", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203014", name: "ABDULLAHI HAFIZ BAYERO", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203015", name: "USMAN GADDAFI BUBUCHE", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203016", name: "IBRAHIM MUHAMMAD", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203017", name: "AMINU SANUSI DURUMBU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203018", name: "NDAMAN ABDULKADIR MOHAMMED", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203019", name: "HAMISU ZAYYANU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203020", name: "ADAMU ABDULLAHI", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203021", name: "BELLO ALHASSAN", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203022", name: "SAADU TASIU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203023", name: "SANI MUBARAK", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203024", name: "WAZIRI  FAHAD", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203025", name: "ABUBAKAR  BELLO  GULUMBE", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203026", name: "IDRIS  ZAINAB  JEGA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203027", name: "USMAN  SARATU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203028", name: "UMAR MANSUR", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203029", name: "AHMAD ISMAIL ABUBAKAR", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203030", name: "UMAR SULEIMAN", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203031", name: "UMAR MUBARAK", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203032", name: "UMAR MUHAMMAD GULUMBE", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203033", name: "SANI LAKABIRU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203034", name: "USMAN NASIRU", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203035", name: "MUSA AISHA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203036", name: "ABDULLAHI ABDULRAZAK", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203037", name: "ABUBAKAR SHAMSIYYA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203038", name: "ADAMU HASSAN BENA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203039", name: "AHMAD SULAIMAN DANTAGAGO", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203040", name: "MUHAMMAD BALA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203041", name: "MUHAMMAD  USMAN  NAGARTA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //         { admissionNumber: "2020203042", name: "AHMAD BASIRA", department: "Computer Science", yearOfAdmin: "2020/2021"},
    //     ]
    //     console.log(typeof docs)
    //     console.log(docs.length)
       
    //         StudentInfo.create(docs, function(err, result){
    
    //         if(err) throw err;
    //         if(result){
    //             console.log('Success')
    //         }
    
    //        })
          
    //     } catch (err) {
    //       console.log(`DB connection error: ${err.message}`);
    //     }
    //   })();

