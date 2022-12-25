import React, { useEffect, useState } from "react";
import { useNavigate, Outlet } from "react-router-dom";

function ProtectedRoutes() {
	const [isAuth, setIsAuth] = useState(false);
	const navigate = useNavigate();

	useEffect(() => {
		let jwtValid = isValidJwt();
        console.log("valid jwt" + jwtValid);

		if (jwtValid) {
			setIsAuth(true);
		} else {
			navigate("/");
		}
	}, [navigate]);

	if (isAuth) {
		return <Outlet/>;
	} else {
		navigate("/");
	}
}

export const isValidJwt = () => {
	try {
		let user = localStorage.getItem("userInfo");
		let decodedJwt;
		if (user) {
			decodedJwt = parseJwt(JSON.parse(user)?.token);
            // console.log(decodedJwt)
		} else {
			// eslint-disable-next-line no-throw-literal
			throw "Invalid User Information";
		}

		if (Date.now() <= decodedJwt?.exp * 1000) {
			return true;
		} else {
			localStorage.removeItem("userInfo");
			return false;
		}
	} catch (e) {
		localStorage.removeItem("userInfo");
		return false;
	}
};

export const parseJwt = (token) => {
    // console.log("token"+ token);
	var base64Url = token.split(".")[1];
	var base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
	var jsonPayload = decodeURIComponent(window.atob(base64).split("").map(function(c) {
		return "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2);
	}).join(""));

	return JSON.parse(jsonPayload);
};

export default ProtectedRoutes;
