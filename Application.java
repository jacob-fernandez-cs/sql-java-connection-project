package CIT304ProjectConnection;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class Application {

	public static void main(String[] args) throws SQLException {

		try {
			callFunction();
			// insertStudentData();
			//getStudentData();
			//getStudentDataById("S05");
		} finally {
			DBConnection.getInstance().getConnection().close();
		}

	}

	private static void callFunction() {

		DBConnection dbConnection = DBConnection.getInstance();
		CallableStatement pstmt =null;

		String state = "VA";
		int val = 100;
		try {
			pstmt = dbConnection.getConnection().prepareCall("{call tax_cost_sp(?,?,?,?)}");
			pstmt.setString(1, state);
			pstmt.setInt(2, val);

			pstmt.registerOutParameter(3, Types.DOUBLE);
			pstmt.registerOutParameter(4, Types.DOUBLE);
			pstmt.execute();

			double tax = pstmt.getDouble(3);
			double rate = pstmt.getDouble(4);
			System.out.print(tax + rate);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

	}

	private static void insertStudentData() {

		DBConnection dbConnection = DBConnection.getInstance();
		PreparedStatement ps;

		try {
			ps = dbConnection.getConnection().prepareStatement("insert into student VALUES (?, ?, ?,?) ");
			int i = 1;
			ps.setString(i++, "S05");
			ps.setString(i++, "SM");
			ps.setString(i++, "222");
			ps.setString(i++, "SM");

			int r = ps.executeUpdate();
			System.out.println("Number of inserts : " + r);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static void getStudentData() {
		DBConnection dbConnection = DBConnection.getInstance();
		PreparedStatement ps;

		try {
			ps = dbConnection.getConnection().prepareStatement("select * from student");
			// ps.setString(1, "%" + name + "%");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				System.out.println(rs.getString("studentname"));

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static void getStudentDataById(String id) {
		DBConnection dbConnection = DBConnection.getInstance();
		PreparedStatement ps;

		try {
			ps = dbConnection.getConnection().prepareStatement("select * from student where STUDENTID = ?");
			ps.setString(1, id);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				System.out.println(rs.getString("studentName"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
