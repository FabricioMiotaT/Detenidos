const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

async function fun() {
    let con;

    try {
        con = await oracledb.getConnection({
            user: "fabricio",
            password: "123",
            connectString: "localhost:1521/freepdb2"
        });

        const data = await con.execute(
            "SELECT * FROM Testigos"
        );
        console.log(data.rows);

    } catch (err) {
        console.error(err);
    } 
}
fun();

