CREATE DATABASE QL_VeMayBay
USE QL_VeMayBay

CREATE TABLE SANBAY 
(
	MaSB CHAR(10) NOT NULL,
	TenSB NVARCHAR(50),
	CONSTRAINT PK_SB_MaSB PRIMARY KEY(MaSB)
);

CREATE TABLE MAYBAY
(
	MaMB CHAR(10) NOT NULL,
	LoaiMB NVARCHAR(50),
	HangBay NVARCHAR(50),
	TongSoGhe INT,
	CONSTRAINT PK_MB_MaMB PRIMARY KEY(MaMB)
);

CREATE TABLE CHANGBAY
(
	MaChangBay CHAR(10) NOT NULL,
	MaSBdi CHAR(10) NOT NULL,
	MaSBden CHAR(10) NOT NULL,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	CONSTRAINT PK_ChB_MaChangBay PRIMARY KEY(MaChangBay),
	CONSTRAINT FK_ChB_MaSBdi FOREIGN KEY(MaSBdi) REFERENCES SANBAY(MaSB),
    CONSTRAINT FK_ChB_MaSBden FOREIGN KEY(MaSBden) REFERENCES SANBAY(MaSB)
);

CREATE TABLE CHUCVU
(
	MaChucVu CHAR(10) NOT NULL,
	TenChucVu NVARCHAR(30),
	CONSTRAINT PK_CV PRIMARY KEY(MaChucVu)
);

CREATE TABLE QLTaiKhoan
(
	IDTaiKhoan CHAR(20) NOT NULL,
	TenTaiKhoan NVARCHAR(50),
    TenDangNhap VARCHAR(50),
	MatKhau VARCHAR(50),
	LoaiTK NVARCHAR(30) CHECK (LoaiTK IN (N'HANHKHACH', N'NHANVIEN')), 
	CONSTRAINT PK_TK PRIMARY KEY(IDTaiKhoan)
);

CREATE TABLE NHANVIEN 
(
	MaNV CHAR(10) NOT NULL,
	TenNV NVARCHAR(50),
	GioiTinhNV NVARCHAR(4) CHECK(GioiTinhNV IN (N'Nam', N'Nữ')),
	LuongNV MONEY,
	NgaySinhNV DATE,
	DiaChiNV NVARCHAR(50),
	SDTnv VARCHAR(11) CHECK (SDTnv LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	MaSB CHAR(10) NOT NULL,
	MaChucVu CHAR(10) NOT NULL,
	IDTaiKhoan CHAR(20) NOT NULL,
	CONSTRAINT PK_NV_MaNV PRIMARY KEY(MaNV),
	CONSTRAINT FK_NV_MaSB FOREIGN KEY(MaSB) REFERENCES SANBAY(MaSB),
	CONSTRAINT FK_NV_MaChucVu FOREIGN KEY(MaChucVu) REFERENCES CHUCVU(MaChucVu),
	CONSTRAINT FK_NV_IDtk FOREIGN KEY(IDTaiKhoan) REFERENCES QLTaiKhoan(IDTaiKhoan)
);

CREATE TABLE CHUYENBAY
(
	MaCB CHAR(10) NOT NULL,
	NgayBay DATE,  
	GioBay TIME,
	GioDen TIME,
	ThoiGianBay TIME,
	SoVeConLai INT,                   -- Số vé còn lại trên chuyến bay
	SoVeDaBan INT,
    TrangThaiChuyenBay NVARCHAR(20),           -- Tình trạng vé (VD: 'Còn vé', 'Hết vé')
	MaMB CHAR(10) NOT NULL,
	MaChangBay CHAR(10) NOT NULL,
	CONSTRAINT PK_CB_MaCB PRIMARY KEY(MaCB),
	CONSTRAINT FK_CB_MaMB FOREIGN KEY(MaMB) REFERENCES MAYBAY(MaMB),
	CONSTRAINT FK_CB_MaChangBay FOREIGN KEY(MaChangBay) REFERENCES CHANGBAY(MaChangBay)
);

CREATE TABLE HANHKHACH 
(
	MaHK CHAR(10) NOT NULL,
	TenHK NVARCHAR(50) DEFAULT '',      
	GioiTinhHK NVARCHAR(4) CHECK(GioiTinhHK IN (N'Nam', N'Nữ')),
	NgaySinhHK DATE DEFAULT NULL,     -- Có thể để NULL nếu không cung cấp giá trị
	DiaChiHK NVARCHAR(50) DEFAULT '',     
	EmailHK VARCHAR(30) DEFAULT '',       
	SDThk CHAR(11) DEFAULT '' CHECK (SDThk LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CCCD CHAR(20) UNIQUE DEFAULT '',    
	HoChieu CHAR(20) UNIQUE DEFAULT '', 
	IDTaiKhoan CHAR(20) NOT NULL,
	CONSTRAINT PK_HK_MaHK PRIMARY KEY(MaHK),
	CONSTRAINT FK_HK_IDtk FOREIGN KEY(IDTaiKhoan) REFERENCES QLTaiKhoan(IDTaiKhoan)
);

CREATE TABLE HANGVE
(
	MaHangVe CHAR(10) NOT NULL,
	TenHangVe NVARCHAR(50),
	CONSTRAINT PK_HVe_MaVe PRIMARY KEY(MaHangVe)
);

CREATE TABLE HANHLY 
(
    MaHL CHAR(10) NOT NULL, -- Định nghĩa là UNIQUEIDENTIFIER
    SoKG FLOAT,
    LoaiHanhLy NVARCHAR(30),
	MaHangVe CHAR(10) NOT NULL,  
    MaHK CHAR(10) NOT NULL,
    MaCB CHAR(10) NOT NULL,
    CONSTRAINT PK_HL_MaHL PRIMARY KEY(MaHL),
	CONSTRAINT FK_HL_MaHangVe FOREIGN KEY(MaHangVe) REFERENCES HANGVE(MaHangVe),
    CONSTRAINT FK_HL_MaHK FOREIGN KEY(MaHK) REFERENCES HANHKHACH(MaHK),
    CONSTRAINT FK_HL_MaCB FOREIGN KEY(MaCB) REFERENCES CHUYENBAY(MaCB)
);

CREATE TABLE CHITIETPHUPHI
(
	MaPhuPhi CHAR(10) NOT NULL,
	PhuPhi MONEY DEFAULT 0,
	LoaiPhuPhi NVARCHAR(50),  -- Thêm loại phụ phí(phụ phí của hành lý hoặc phụ phí của dịch vụ (nếu có))
	MaHL CHAR(10) NOT NULL,
	CONSTRAINT PK_CTPhuPhi_MaPhuPhi PRIMARY KEY(MaPhuPhi),
	CONSTRAINT FK_CTPhuPhi_MaHL FOREIGN KEY(MaHL) REFERENCES HANHLY(MaHL)
);

CREATE TABLE GIAVE
(
	MaGiaVe CHAR(10) NOT NULL,
	GiaCoBan MONEY,
	TongGiaVe MONEY DEFAULT 0,
	GiamGia MONEY DEFAULT 0,
	MaPhuPhi CHAR(10) NOT NULL,
	MaCB CHAR(10) NOT NULL,
	MaHangVe CHAR(10) NOT NULL,
	CONSTRAINT PK_GV_MaGiaVe PRIMARY KEY(MaGiaVe),
	CONSTRAINT FK_GV_MaPhuPhi FOREIGN KEY (MaPhuPhi) REFERENCES CHITIETPHUPHI(MaPhuPhi),
	CONSTRAINT FK_GV_MaCB FOREIGN KEY(MaCB) REFERENCES CHUYENBAY(MaCB),
	CONSTRAINT FK_GV_MaHangVe FOREIGN KEY(MaHangVe) REFERENCES HANGVE(MaHangVe)
);

CREATE TABLE DATVE
(
	MaDV CHAR(10) NOT NULL,
	ThanhTien MONEY DEFAULT 0,
	SoVeDat INT DEFAULT 0,
	NgayDatVe DATE,  
	--MaVe CHAR(10) NOT NULL,
	MaCB CHAR(10) NOT NULL,
	MaHK CHAR(10) NOT NULL,
	CONSTRAINT PK_DV_MaDV PRIMARY KEY(MaDV),
	--CONSTRAINT FK_DV_MaVe FOREIGN KEY(MaVe) REFERENCES VE(MaVe),
	CONSTRAINT FK_DV_MaHK FOREIGN KEY(MaHK) REFERENCES HANHKHACH(MaHK),
	CONSTRAINT FK_DV_MaCB FOREIGN KEY(MaCB) REFERENCES CHUYENBAY(MaCB)
);

CREATE TABLE HOADON
(
    MaHD CHAR(10) NOT NULL,
    MaDV CHAR(10) NOT NULL,            
    NgayLapHD DATE NOT NULL,                    
    TongTien MONEY DEFAULT 0,                    
    HinhThucThanhToan NVARCHAR(20),    -- Hình thức thanh toán (VD: 'Tiền mặt', 'Chuyển khoản')
	TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán', N'Đã hoàn tiền')),  -- Trạng      thái thanh toán
    CONSTRAINT PK_HD PRIMARY KEY(MaHD),
    CONSTRAINT FK_HD_MaDV FOREIGN KEY(MaDV) REFERENCES DATVE(MaDV)
);

CREATE TABLE LICHSUGIAODICH
(
    MaGD CHAR(10) NOT NULL,            
    MaHD CHAR(10) NOT NULL,            
    NgayGiaoDich DATETIME NOT NULL,    -- Ngày và giờ giao dịch         
    TrangThaiDatVe NVARCHAR(20),          -- Trạng thái đặt vé (VD: 'Đã xác nhận', 'Đã hủy')
    CONSTRAINT PK_LSGD_MaGD PRIMARY KEY(MaGD),
    CONSTRAINT FK_LSGD_MaHD FOREIGN KEY(MaHD) REFERENCES HOADON(MaHD)  
);

CREATE TABLE VE 
(
	MaVe CHAR(10) NOT NULL,
	DonViTien NCHAR(10),
	ViTriGhe CHAR(10),
	--TrangThai NVARCHAR(20),
	MaHK CHAR(10) NOT NULL, 
	MaDV CHAR(10) NOT NULL,
	MaGiaVe CHAR(10) NOT NULL,
	CONSTRAINT PK_VE_MaVe PRIMARY KEY(MaVe),
	CONSTRAINT FK_VE_MaHK FOREIGN KEY(MaHK) REFERENCES HANHKHACH(MaHK),
	CONSTRAINT FK_VE_MaDV FOREIGN KEY(MaDV) REFERENCES DATVE(MaDV),
	CONSTRAINT FK_VE_MaGiaVe FOREIGN KEY(MaGiaVe) REFERENCES GIAVE(MaGiaVe)
);

CREATE TABLE NHANXET
(
	MaHK CHAR(10) NOT NULL,
	MaCB CHAR(10) NOT NULL,
	NDNhanXet NVARCHAR(100),
	DiemDanhGia INT CHECK (DiemDanhGia BETWEEN 1 AND 5),
	CONSTRAINT PK_NX_MaHK_MaCB PRIMARY KEY(MaHK, MaCB),
	CONSTRAINT FK_NX_MaHK FOREIGN KEY(MaHK) REFERENCES HANHKHACH(MaHK),
	CONSTRAINT FK_NX_MaCB FOREIGN KEY(MaCB) REFERENCES CHUYENBAY(MaCB)
);

-----------------------------------------------------------------------
--								DỮ LIỆU
-----------------------------------------------------------------------
INSERT INTO SANBAY (MaSB, TenSB)
VALUES 
    ('SB001', N'Sân bay Tân Sơn Nhất'),
    ('SB002', N'Sân bay Nội Bài'),
    ('SB003', N'Sân bay Đà Nẵng'),
    ('SB004', N'Sân bay Cam Ranh'),
    ('SB005', N'Sân bay Phú Quốc');

INSERT INTO MAYBAY (MaMB, LoaiMB, HangBay, TongSoGhe)
VALUES 
    ('MB001', N'Airbus A320', N'VietJet Air', 180),
    ('MB002', N'Boeing 787', N'Vietnam Airlines', 300),
    ('MB003', N'Airbus A321', N'Bamboo Airways', 220),
    ('MB004', N'Boeing 777', N'Vietnam Airlines', 350),
    ('MB005', N'Airbus A330', N'Bamboo Airways', 260);

INSERT INTO CHANGBAY (MaChangBay, MaSBdi, MaSBden)
VALUES 
    ('CBY001', 'SB001', 'SB002'),
    ('CBY002', 'SB002', 'SB003'),
    ('CBY003', 'SB003', 'SB004'),
    ('CBY004', 'SB004', 'SB005'),
    ('CBY005', 'SB005', 'SB001');

INSERT INTO CHUCVU (MaChucVu, TenChucVu)
VALUES 
    ('CV001', N'Quản lý'),
    ('CV002', N'Nhân viên');

INSERT INTO QLTaiKhoan (IDTaiKhoan, TenTaiKhoan, TenDangNhap, MatKhau, LoaiTK)
VALUES 
    ('TK001',  N'Nguyễn Văn A', 'nguyenvana', 'password123', N'NHANVIEN'),
    ('TK002',  N'Trần Thị B', 'tranthib', 'password456', N'NHANVIEN'),
    ('TK003', N'Lê Văn C', 'levanc', 'pass789', N'NHANVIEN'),
    ('TK004', N'Phạm Thị D', 'phamthid', 'secret123', N'NHANVIEN'),
    ('TK005', N'Hoàng Văn E', 'hoangvane', 'secure456', N'NHANVIEN'),
    ('TK006', N'Nguyễn Văn F', 'nguyenvanf1', 'password123', N'HANHKHACH'),
    ('TK007', N'Trần Thị G', 'tranthig1', 'password456', N'HANHKHACH'),
    ('TK008', N'Lê Văn H', 'levanh1', 'pass789', N'HANHKHACH'),
    ('TK009', N'Phạm Thị K', 'phamthik1', 'secret123', N'HANHKHACH'),
    ('TK010', N'Hoàng Văn L', 'hoangvanl1', 'secure456', N'HANHKHACH');

INSERT INTO NHANVIEN (MaNV, TenNV, GioiTinhNV, LuongNV, NgaySinhNV, DiaChiNV, SDTnv, MaSB, MaChucVu, IDTaiKhoan) 
VALUES 
	('NV001', N'Nguyễn Văn X', N'Nam', 15000000, '1980-01-01', N'Thành phố Hồ Chí Minh', '0905123456', 'SB001', 'CV001', 'TK001'),
	('NV002', N'Trần Thị Y', N'Nữ', 16000000, '1985-02-02', N'Hà Nội', '0906123456', 'SB002', 'CV002', 'TK002'),
	('NV003', N'Lê Văn Z', N'Nam', 17000000, '1990-03-03', N'Đà Nẵng', '0907123456', 'SB003', 'CV002', 'TK003'),
	('NV004', N'Phạm Thị M', N'Nữ', 18000000, '1982-04-04', N'Hải Phòng', '0908123456', 'SB004', 'CV002', 'TK004'),
	('NV005', N'Hoàng Văn N', N'Nam', 19000000, '1987-05-05', N'Cần Thơ', '0909123456', 'SB005', 'CV002', 'TK005');

INSERT INTO CHUYENBAY (MaCB, NgayBay, GioBay, GioDen, ThoiGianBay, MaMB, MaChangBay)
VALUES 
    ('CB001', '2024-10-15', '08:00', '10:00', '02:00', 'MB001', 'CBY001'),
    ('CB002', '2024-10-16', '14:00', '16:30', '02:30', 'MB002', 'CBY002'),
    ('CB003', '2024-10-17', '09:00', '11:30', '02:30', 'MB003', 'CBY003'),
    ('CB004', '2024-10-18', '13:00', '15:30', '02:30', 'MB004', 'CBY004'),
    ('CB005', '2024-10-19', '17:00', '19:30', '02:30', 'MB005', 'CBY005');

INSERT INTO HANHKHACH (MaHK, TenHK, GioiTinhHK, NgaySinhHK, DiaChiHK, EmailHK, SDThk, CCCD, HoChieu, IDTaiKhoan) 
VALUES 
    ('HK001', N'Nguyễn Văn F', N'Nam', '1990-01-01', N'Thành phố Hồ Chí Minh', 'f.nguyen@example.com', '0909123456', '0123456789', 'A1234567', 'TK006'),
    ('HK002', N'Trần Thị G', N'Nữ', '1992-02-02', N'Bến Tre', 'g.tran@example.com', '0912123456', '9876543210', 'B1234567', 'TK007'),
    ('HK003', N'Lê Văn H', N'Nam', '1988-03-03', N'Phú Quốc', 'h.le@example.com', '0903123456', '1234567890', 'C1234567', 'TK008'),
    ('HK004', N'Phạm Thị K', N'Nữ', '1991-04-04', N'Tiền Giang', 'k.pham@example.com', '0918123456', '0987654321', 'D1234567', 'TK009'),
    ('HK005', N'Hoàng Văn L', N'Nam', '1985-05-05', N'Yên Bái', 'l.hoang@example.com', '0904123456', '2345678901', 'E1234567', 'TK010');

INSERT INTO HANGVE (MaHangVe, TenHangVe) 
VALUES 
	('HV001', N'Hạng thương gia'),
	('HV002', N'Hạng phổ thông');

----------------------------------------------------
INSERT INTO HANHLY (MaHL, SoKG, LoaiHanhLy, MaHangVe, MaHK, MaCB) 
VALUES 
    ('HL001', 35, N'Hành lý ký gửi', 'HV001', 'HK001', 'CB001'), 
    ('HL002', 25, N'Hành lý ký gửi', 'HV002', 'HK002', 'CB002'),
    ('HL003', 5, N'Hành lý xách tay', 'HV001', 'HK001', 'CB001'),
    ('HL004', 8, N'Hành lý xách tay', 'HV002', 'HK002', 'CB002'),
    ('HL005', 30, N'Hành lý ký gửi', 'HV002', 'HK005', 'CB005');


INSERT INTO CHITIETPHUPHI (MaPhuPhi, PhuPhi, LoaiPhuPhi, MaHL)
VALUES
    ('PP001', 0, N'Hành lý', 'HL001'),
    ('PP002', 200000, N'Hành lý', 'HL002'),
    ('PP003', 0, N'Hành lý', 'HL003'),
    ('PP004', 70000, N'Hành lý', 'HL004'),
    ('PP005', 350000, N'Hành lý', 'HL005');



INSERT INTO GIAVE (MaGiaVe, GiaCoBan, TongGiaVe, TongPhuPhi, GiamGia, MaCB, MaHangVe, NgayDatVe)
VALUES 
    ('GV001', 2000000, 0, 0, 0, 'CB001', 'HV001', '2024-10-01'),
    ('GV002', 3500000, 0, 0, 0, 'CB002', 'HV002', '2024-10-02'),
    ('GV003', 5000000, 0, 0, 0, 'CB003', 'HV003', '2024-10-03'),
    ('GV004', 4000000, 0, 0, 0, 'CB004', 'HV004', '2024-10-04'),
    ('GV005', 1500000, 0, 0, 0, 'CB005', 'HV004', '2024-10-05');
----------------------------------------------------
INSERT INTO DATVE (MaDV, ThanhTien, SoVeDat, MaCB, MaHK)
VALUES 
    ('DV001', 0, 1, 'CB001', 'HK001'),
    ('DV002', 0, 1, 'CB002', 'HK002'),
    ('DV003', 0, 1, 'CB003', 'HK003'),
    ('DV004', 0, 1, 'CB004', 'HK004'),
    ('DV005', 0, 1, 'CB005', 'HK005');
----------------------------------------------------
INSERT INTO VE (MaVe, DonViTien, ViTriGhe, MaHK, MaDV, MaGiaVe) 
VALUES 
	('VE001', 'VND', 'A1', 'HK001', 'DV001', 'GV001'),
	('VE002', 'VND', 'B2', 'HK002', 'DV002', 'GV002'),
	('VE003', 'VND', 'C3', 'HK003', 'DV003', 'GV003'),
	('VE004', 'VND', 'D4', 'HK004', 'DV004', 'GV004'),
	('VE005', 'VND', 'E5', 'HK005', 'DV005', 'GV005');
----------------------------------------------------
INSERT INTO NHANXET (MaHK, MaCB, NDNhanXet, DiemDanhGia)
VALUES 
    ('HK001', 'CB001', N'Trải nghiệm tuyệt vời, rất hài lòng.', 5),
    ('HK002', 'CB002', N'Dịch vụ tốt, nhưng có thể cải thiện.', 4),
    ('HK003', 'CB003', N'Chuyến bay ổn, nhưng ghế hơi chật.', 3),
    ('HK004', 'CB004', N'Trễ chuyến bay, nhưng nhân viên hỗ trợ tốt.', 4),
    ('HK005', 'CB005', N'Chuyến bay hoàn hảo, không có gì để chê.', 5);

--	XEM DỮ LIỆU BẢNG
SELECT * FROM SANBAY
SELECT * FROM MAYBAY
SELECT * FROM CHANGBAY
SELECT * FROM CHUCVU
SELECT * FROM QLTaiKhoan
SELECT * FROM NHANVIEN
SELECT * FROM CHUYENBAY
SELECT * FROM HANHKHACH
SELECT * FROM HANGVE
SELECT * FROM HANHLY
SELECT * FROM CHITIETPHUPHI
SELECT * FROM GIAVE
SELECT * FROM VE
SELECT * FROM DATVE
SELECT * FROM NHANXET

DELETE FROM SANBAY
DELETE FROM MAYBAY
DELETE FROM CHANGBAY
DELETE FROM CHUCVU
DELETE FROM QLTaiKhoan
DELETE FROM NHANVIEN
DELETE FROM CHUYENBAY
DELETE FROM HANHKHACH
DELETE FROM HANGVE
DELETE FROM HANHLY
DELETE FROM CHITIETPHUPHI
DELETE FROM GIAVE
DELETE FROM VE
DELETE FROM DATVE
DELETE FROM NHANXET

--TRIGGER
--1. Tính giá vé (GIAVE)
--2. Tính thành tiền (DATVE)
--3. Tính phụ phí --
--4. Check tuổi
-----------------------------------------------------------------------
--									SANBAY
-----------------------------------------------------------------------
-- Trigger kiểm tra trùng MaSB
CREATE TRIGGER trg_SANBAY_CHECK_MaSB
ON SANBAY
FOR INSERT, UPDATE 
AS
BEGIN
    IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM SANBAY sb
			WHERE sb.MaSB = i.MaSB 
				  AND MaSB NOT IN (SELECT MaSB FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã sân bay đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

-- Trigger để kiểm tra trước khi chèn và cập nhật vào SANBAY
CREATE TRIGGER trg_SANBAY_ThemMoi
ON SANBAY
FOR INSERT, UPDATE 
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED WHERE TenSB = '')
		BEGIN
			PRINT N'Tên sân bay không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-- Trigger để ghi log khi xóa SANBAY
CREATE TRIGGER trg_SANBAY_DELETE
ON SANBAY
FOR DELETE
AS
BEGIN
    DECLARE @MaSB CHAR(10);
    SELECT @MaSB = MaSB FROM DELETED;
    
    PRINT N'Sân bay có mã ' + @MaSB + N' đã bị xóa khỏi hệ thống.';
END;

-----------------------------------------------------------------------
--								MAYBAY
-----------------------------------------------------------------------
-- Trigger kiểm tra trùng MaMB 
CREATE TRIGGER trg_MAYBAY_CHECK_MaMB
ON MAYBAY
FOR INSERT, UPDATE 
AS
BEGIN
    -- Kiểm tra nếu mã đã tồn tại ở bản ghi khác
    IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM MAYBAY mb
			WHERE mb.MaMB = i.MaMB 
				  AND MaMB NOT IN (SELECT MaMB FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã máy bay đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

-- Trigger kiểm tra khi chèn và cập nhật dữ liệu vào bảng MAYBAY
CREATE TRIGGER trg_MAYBAY_ThemMoi
ON MAYBAY
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu LoaiMB để trống
    IF EXISTS (SELECT 1 FROM INSERTED WHERE LoaiMB = '')
		BEGIN
			PRINT N'Loại máy bay không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END

    -- Kiểm tra nếu HangBay để trống
    IF EXISTS (SELECT 1 FROM INSERTED WHERE HangBay = '')
		BEGIN
			PRINT N'Hãng bay không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END

    -- Kiểm tra nếu TongSoGhe không hợp lệ (ví dụ: nhỏ hơn hoặc bằng 0)
    IF EXISTS (SELECT 1 FROM INSERTED WHERE TongSoGhe <= 0)
		BEGIN
			PRINT N'Tổng số ghế phải lớn hơn 0!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-- Trigger để ghi log khi xóa MAYBAY
CREATE TRIGGER trg_MAYBAY_DELETE
ON MAYBAY
FOR DELETE
AS
BEGIN
    DECLARE @MaMB CHAR(10);
    SELECT @MaMB = MaMB FROM DELETED;

    PRINT N'Máy bay có mã ' + @MaMB + N' đã bị xóa khỏi hệ thống.';
END;

-----------------------------------------------------------------------
--								CHANGBAY
-----------------------------------------------------------------------
-- Trigger kiểm tra trùng MaChangBay
CREATE TRIGGER trg_CHANGBAY_CHECK_MaChangBay
ON CHANGBAY
FOR INSERT, UPDATE 
AS
BEGIN
    -- Kiểm tra nếu mã đã tồn tại ở bản ghi khác
    IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS(
			SELECT 1 
			FROM CHANGBAY chb
			WHERE chb.MaChangBay = i.MaChangBay 
				  AND MaChangBay NOT IN (SELECT MaChangBay FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã chặng bay đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

-- Trigger để kiểm tra trước khi chèn và cập nhật vào CHANGBAY
CREATE TRIGGER trg_CHANGBAY_ThemMoi
ON CHANGBAY
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED WHERE MaSBdi = MaSBden)
		BEGIN
			PRINT N'Mã sân bay đi và sân bay đến không được trùng nhau!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-- Trigger để ghi log khi xóa CHANGBAY
CREATE TRIGGER trg_CHANGBAY_DELETE
ON CHANGBAY
FOR DELETE
AS
BEGIN
    DECLARE @MaChangBay CHAR(10);
    SELECT @MaChangBay = MaChangBay FROM DELETED;

    PRINT N'Chặng bay có mã ' + @MaChangBay + N' đã bị xóa khỏi hệ thống.';
END;

-----------------------------------------------------------------------
--								CHUCVU
-----------------------------------------------------------------------
-- Trigger kiểm tra giá trị của TenChucVu chỉ là 'Nhân viên đặt vé' hoặc 'Quản lý'
CREATE TRIGGER trg_CHUCVU_TenChucVu
ON CHUCVU
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu có bất kỳ bản ghi nào trong INSERTED có TenChucVu không hợp lệ
    IF EXISTS (
        SELECT 1 
        FROM INSERTED 
        WHERE TenChucVu NOT IN (N'Nhân viên', N'Quản lý')
    )
		BEGIN
			PRINT N'Tên chức vụ không hợp lệ! Chỉ được phép là "Nhân viên" hoặc "Quản lý".';
			ROLLBACK TRANSACTION;
		END
END;

-----------------------------------------------------------------------
--								QLTaiKhoan
-----------------------------------------------------------------------
-- Trigger kiểm tra trùng IDTaiKhoan
CREATE TRIGGER trg_QLTaiKhoan_CHECK_IDTaiKhoan
ON QLTaiKhoan
FOR INSERT, UPDATE 
AS
BEGIN
    -- Kiểm tra nếu mã đã tồn tại ở bản ghi khác
    IF EXISTS (
		SELECT 1 
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM QLTaiKhoan qltk
			WHERE qltk.IDTaiKhoan = i.IDTaiKhoan
				  AND qltk.IDTaiKhoan NOT IN (SELECT IDTaiKhoan FROM DELETED)
		)
	)
		BEGIN
			PRINT N'ID tài khoản đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra khi thêm mới vào QLTaiKhoan
CREATE TRIGGER trg_QLTaiKhoan_ThemMoi
ON QLTaiKhoan
FOR INSERT, UPDATE
AS
BEGIN
	--Kiểm tra TenTaiKhoan để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE TenTaiKhoan = '')
		BEGIN
			PRINT N'Tên tài khoản không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra TenDangNhap để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE TenDangNhap = '')
		BEGIN
			PRINT N'Tên đăng nhập không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra MatKhau để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE MatKhau = '')
		BEGIN
			PRINT N'Mật khẩu không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-----------------------------------------------------------------------
--								NHANVIEN
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaNV
CREATE TRIGGER trg_NHANVIEN_CHECK_MaNV
ON NHANVIEN 
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM NHANVIEN nv
			WHERE nv.MaNV = i.MaNV
				  AND nv.MaNV NOT IN (SELECT MaNV FROM DELETED)  -- Đảm bảo không kiểm tra chính bản ghi đang cập nhật
		)
	)
		BEGIN
			PRINT N'Mã nhân viên này đã tồn tại!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra khi thêm mới vào NHANVIEN
CREATE TRIGGER trg_NHANVIEN_ThemMoi
ON NHANVIEN
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @TenNV NVARCHAR(50),
			@GioiTinh NVARCHAR(4),
			@Luong MONEY,
			@NgaySinhNV DATE,
			@DiaChiNV NVARCHAR(50),
			@SDTnv VARCHAR(11);
	
	SELECT @TenNV = TenNV, 
		   @GioiTinh = GioiTinhNV, 
		   @Luong = LuongNV, 
		   @NgaySinhNV = NgaySinhNV, 
		   @DiaChiNV = DiaChiNV, 
		   @SDTnv = SDTnv 
	FROM INSERTED;

	--Kiểm tra TenNV để trống
	IF @TenNV = ''
		BEGIN
			PRINT N'Tên nhân viên không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra GioiTinhNV để trống
	IF @GioiTinh NOT IN (N'Nam', N'Nữ')
		BEGIN
			PRINT N'Giới tính của nhân viên phải là "Nam" hoặc "Nữ"!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra Luong
	IF @Luong IS NULL
		BEGIN
			PRINT N'Lương của nhân viên không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF @Luong <= 0
		BEGIN
			PRINT N'Lương của nhân viên phải lớn hơn 0!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra NgaySinhNV 
	IF @NgaySinhNV IS NULL 
		BEGIN
			PRINT N'Ngày sinh không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF @NgaySinhNV >= GETDATE()
		BEGIN
			PRINT N'Ngày sinh phải nhỏ hơn ngày hiện tại!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra DiaChiNV để trống
	IF @DiaChiNV = ''
		BEGIN
			PRINT N'Địa chỉ nhân viên không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	-- Kiểm tra SDTnv nhân viên (phải là 10 chữ số)
	IF LEN(@SDTnv) <> 10 OR @SDTnv NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	BEGIN
		PRINT N'Số điện thoại nhân viên phải có đúng 10 chữ số!';
		ROLLBACK TRANSACTION;
		RETURN;
	END
END;

-----------------------------------------------------------------------
--								CHUYENBAY
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaCB
CREATE TRIGGER trg_CHUYENBAY_MaCB
ON CHUYENBAY 
FOR INSERT, UPDATE
AS
BEGIN 
	IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1
			FROM CHUYENBAY cb 
			WHERE cb.MaCB = i.MaCB 
				  AND cb.MaCB NOT IN (SELECT MaCB FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã chuyến bay đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra khi thêm mới vào CHUYENBAY
CREATE TRIGGER trg_CHUYENBAY_ThemMoi
ON CHUYENBAY
FOR INSERT, UPDATE
AS
BEGIN 
	--Kiểm tra NgayBay để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE NgayBay IS NULL)
		BEGIN
			PRINT N'Ngày bay không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF EXISTS (SELECT 1 FROM INSERTED WHERE NgayBay <= GETDATE())
		BEGIN 
			PRINT N'Ngày bay phải lớn hơn ngày hiện tại!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra GioBay để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE GioBay IS NULL) 
		BEGIN 
			PRINT N'Giờ bay không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF EXISTS (SELECT 1 FROM INSERTED WHERE GioBay > GioDen)
		BEGIN
			PRINT N'Giờ bay phải nhỏ hơn giờ đến!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra GioDen để trống
	IF EXISTS (SELECT 1 FROM INSERTED WHERE GioDen IS NULL)
		BEGIN
			PRINT N'Giờ đến không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF EXISTS (SELECT 1 FROM INSERTED WHERE GioDen < GioBay)
		BEGIN
			PRINT N'Giờ đến phải lớn hơn giờ bay!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	BEGIN
		--Kiểm tra ThoiGianBay để trống
		IF EXISTS (SELECT 1 FROM INSERTED WHERE ThoiGianBay IS NULL)
			BEGIN
				PRINT N'Thời gian bay không được để trống!';
				ROLLBACK TRANSACTION;
				RETURN
			END
		ELSE 
		-- Tính toán thời gian bay (...giờ...phút) và cập nhật
		UPDATE CHUYENBAY
		SET ThoiGianBay = 
			CAST(DATEDIFF(MINUTE, i.GioBay, i.GioDen) / 60 AS VARCHAR) + N' giờ ' + 
			CAST(DATEDIFF(MINUTE, i.GioBay, i.GioDen) % 60 AS VARCHAR) + N' phút'
		FROM CHUYENBAY cb
		JOIN INSERTED i ON cb.MaCB = i.MaCB;
	END;
END;

-----------------------------------------------------------------------
--								HANHKHACH
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaHK 
CREATE TRIGGER trg_HANHKHACH_MaHK
ON HANHKHACH
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1
			FROM HANHKHACH hk
			WHERE hk.MaHK = i.MaHK
				  AND hk.MaHK NOT IN (SELECT MaHK FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã hành khách đã tồn tại trong bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra khi thêm mới
CREATE TRIGGER trg_HANHKHACH_ThemMoi
ON HANHKHACH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @TenHK NVARCHAR(50),
			@GioiTinhHK NVARCHAR(4),
			@NgaySinhHK DATE,
			@DiaChiHK NVARCHAR(50),
			@EmailHK VARCHAR(30),
			@SDThk CHAR(11),
			@CCCD CHAR(20),
			@HoChieu CHAR(20);

	SELECT @TenHK = TenHK,
		   @GioiTinhHK = GioiTinhHK,
		   @NgaySinhHK = NgaySinhHK,
		   @DiaChiHK = DiaChiHK,
		   @EmailHK = EmailHK,
		   @SDThk = SDThk,
		   @CCCD = CCCD,
		   @HoChieu = HoChieu
	FROM INSERTED;

	--Kiểm tra TenHK để trống
	IF @TenHK = ''
		BEGIN
			PRINT N'Tên hành khách không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra GioiTinhHK để trống
	IF @GioiTinhHK = ''
		BEGIN
			PRINT N'Giới tính hành khách không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra NgaySinhHK 
	IF @NgaySinhHK IS NULL
		BEGIN
			PRINT N'Ngày sinh không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF EXISTS (SELECT 1 FROM INSERTED WHERE @NgaySinhHK >= GETDATE())
		BEGIN
			PRINT N'Ngày sinh hành khách phải nhỏ hơn ngày hiện tại!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra DiaChiHK để trống
	IF @DiaChiHK = ''
		BEGIN
			PRINT N'Địa chỉ của hành khách không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	--Kiểm tra EmailHK để trống
	IF @EmailHK = ''
		BEGIN
			PRINT N'Email hành khách không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	-- Kiểm tra SDThk hành khách (phải là 10 chữ số)
	IF LEN(@SDThk) <> 10 OR @SDThk NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	BEGIN
		PRINT N'Số điện thoại hành khách phải có đúng 10 chữ số!';
		ROLLBACK TRANSACTION;
		RETURN;
	END
END;

-----------------------------------------------------------------------
--								HANGVE
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaHangVe
CREATE TRIGGER trg_HANGVE_MaHangVe
ON HANGVE
FOR INSERT, UPDATE
AS
BEGIN 
	IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1
			FROM HANGVE hv
			WHERE hv.MaHangVe = i.MaHangVe
				  AND hv.MaHangVe NOT IN (SELECT MaHangVe FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã hạng vé đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra TenHangVe để trống khi thêm mới
CREATE TRIGGER trg_HANGVE_ThemMoi
ON HANGVE
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM INSERTED WHERE TenHangVe = '')
		BEGIN
			PRINT N'Tên hạng vé không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-----------------------------------------------------------------------
--								HANHLY
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaHL
CREATE TRIGGER trg_HANHLY_MaHL
ON HANHLY
FOR INSERT, UPDATE 
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1
			FROM HANHLY hl
			WHERE hl.MaHL = i.MaHL
				  AND hl.MaHL NOT IN (SELECT 1 FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã hành lý đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger kiểm tra khi thêm mới 
CREATE TRIGGER trg_HANHLY_ThemMoi
ON HANHLY
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @SoKG FLOAT,
			@LoaiHanhLy NVARCHAR(30);

	SELECT @SoKG = SoKG,
		   @LoaiHanhLy = LoaiHanhLy
	FROM INSERTED;

	IF @SoKG = 0
		BEGIN 
			PRINT N'Số kg không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END

	IF @LoaiHanhLy = ''
		BEGIN 
			PRINT N'Loại hành lý không được để trống!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
	ELSE IF @LoaiHanhLy = N'Hành lý ký gửi' OR @LoaiHanhLy = N'Hành lý xách tay'
		BEGIN
			PRINT N'Loại hành lý chỉ có "Hành lý ký gửi" và "Hành lý xách tay"!';
			ROLLBACK TRANSACTION;
			RETURN;
		END
END;

-----------------------------------------------------------------------
--							CHITIETPHUPHI
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaPhuPhi
CREATE TRIGGER trg_CHITIETPHUPHI_MaPhuPhi
ON CHITIETPHUPHI
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM CHITIETPHUPHI ctpp
			WHERE ctpp.MaPhuPhi = i.MaPhuPhi
				  AND ctpp.MaPhuPhi NOT IN (SELECT 1 FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã phụ phí đã tồn tại ở bản ghi khác!';
			ROLLBACK TRANSACTION;
		END
END;

--Trigger tính phụ phí
CREATE TRIGGER trg_UpdatePhuPhi
ON CHITIETPHUPHI
AFTER INSERT, UPDATE
AS
BEGIN
    -- Cập nhật phụ phí dựa trên loại hành lý và hạng vé
    UPDATE CHITIETPHUPHI
    SET PhuPhi = 
        CASE 
            -- Hành lý ký gửi, hạng phổ thông
            WHEN h.LoaiHanhLy = N'Hành lý ký gửi' 
                 AND hv.TenHangVe = N'Hạng phổ thông' 
                 AND h.SoKG > 23 
            THEN (h.SoKG - 23) * 70000

            -- Hành lý ký gửi, hạng thương gia
            WHEN h.LoaiHanhLy = N'Hành lý ký gửi' 
                 AND hv.TenHangVe = N'Hạng thương gia' 
                 AND h.SoKG > 32 
            THEN (h.SoKG - 32) * 70000

            -- Hành lý xách tay, hạng phổ thông
            WHEN h.LoaiHanhLy = N'Hành lý xách tay' 
                 AND hv.TenHangVe = N'Hạng phổ thông' 
                 AND h.SoKG > 7 
            THEN (h.SoKG - 7) * 70000

            -- Hành lý xách tay, hạng thương gia
            WHEN h.LoaiHanhLy = N'Hành lý xách tay' 
                 AND hv.TenHangVe = N'Hạng thương gia' 
                 AND h.SoKG > 10 
            THEN (h.SoKG - 10) * 70000

            -- Không vượt quá giới hạn, phụ phí là 0
            ELSE 0
        END
    FROM CHITIETPHUPHI ctp
    JOIN HANHLY h ON ctp.MaHL = h.MaHL
    JOIN HANGVE hv ON h.MaHangVe = hv.MaHangVe
    INNER JOIN inserted i ON ctp.MaPhuPhi = i.MaPhuPhi;
END;

-----------------------------------------------------------------------
--								  GIAVE
-----------------------------------------------------------------------
--Trigger kiểm tra trùng MaGiaVe
CREATE TRIGGER trg_GIAVE_MaGiaVe
ON GIAVE
FOR INSERT, UPDATE
AS
BEGIN 
	IF EXISTS (
		SELECT 1 
		FROM INSERTED i
		WHERE EXISTS (
			SELECT 1 
			FROM GIAVE gv
			WHERE gv.MaGiaVe = i.MaGiaVe
				  AND gv.MaGiaVe NOT IN (SELECT 1 FROM DELETED)
		)
	)
		BEGIN
			PRINT N'Mã giá vé không được trùng!';
			ROLLBACK TRANSACTION;
		END
END;

--Tính GiamGia theo tuổi của hành khách
CREATE PROCEDURE sp_TinhGiamGiaTheoTuoi
    @MaHK CHAR(10),
    @MaCB CHAR(10),
    @MaHangVe CHAR(10),
    @GiaVeNguoiLon MONEY
AS
BEGIN
    DECLARE @NgaySinh DATE, 
            @Tuoi INT, 
            @GiamGia MONEY;

    -- Lấy ngày sinh của hành khách
    SELECT @NgaySinh = NgaySinhHK FROM HANHKHACH WHERE MaHK = @MaHK;

    -- Tính tuổi của hành khách tính đến ngày khởi hành
    SELECT @Tuoi = DATEDIFF(YEAR, @NgaySinh, (SELECT NgayBay FROM CHUYENBAY WHERE MaCB = @MaCB));

    -- Tính giảm giá dựa trên độ tuổi
    IF @Tuoi < 2
    BEGIN
        SET @GiamGia = @GiaVeNguoiLon * 0.1; -- Giảm 10% cho trẻ sơ sinh
    END
    ELSE IF @Tuoi >= 2 AND @Tuoi < 12
    BEGIN
        SET @GiamGia = @GiaVeNguoiLon * 0.75; -- Giảm 75% cho trẻ em
    END
    ELSE
    BEGIN
        SET @GiamGia = 0; -- Không giảm giá cho người lớn
    END

    -- Cập nhật giá vé sau khi tính giảm giá
    UPDATE GIAVE
    SET GiamGia = @GiamGia,
        TongGiaVe = @GiaVeNguoiLon - @GiamGia
    WHERE MaCB = @MaCB AND MaHangVe = @MaHangVe;
END;

CREATE TRIGGER trg_TinhGiamGia_AfterInsert
ON DATVE
AFTER INSERT
AS
BEGIN
    DECLARE @MaHK CHAR(10), 
            @MaCB CHAR(10), 
            @MaHangVe CHAR(10), 
            @GiaVeNguoiLon MONEY;

    -- Lấy thông tin hành khách, chuyến bay và hạng vé từ bảng DATVE và GIAVE
    SELECT @MaHK = inserted.MaHK, 
           @MaCB = inserted.MaCB, 
           @MaHangVe = GV.MaHangVe,
           @GiaVeNguoiLon = GV.GiaCoBan  -- Lấy giá vé cơ bản từ bảng GIAVE
    FROM inserted
    JOIN GIAVE GV ON GV.MaCB = inserted.MaCB;

    -- Gọi stored procedure để tính toán giảm giá dựa theo độ tuổi
    EXEC sp_TinhGiamGiaTheoTuoi @MaHK, @MaCB, @MaHangVe, @GiaVeNguoiLon;
END;



--Ràng buộc giới hạn mã (3 chữ cái 3 chữ số)
--Xuất thông tin nhân viên
--Xuất thông tin hành khách
--Xuất thông tin chuyến bay, sân bay, máy bay
--Xuất thông tin vé
--Xuất thông tin lịch sử đặt vé

--Tính TongPhuPhi
CREATE PROCEDURE sp_TinhTongPhuPhi_GiaVe @MaGiaVe CHAR(10)
AS
BEGIN
    DECLARE @TongPhuPhi MONEY;

    -- Tính tổng phụ phí cho tất cả các hành lý của hành khách thuộc vé này
    SELECT @TongPhuPhi = SUM(ctpp.PhuPhi)
    FROM CHITIETPHUPHI ctpp
    JOIN HANHLY hl ON ctpp.MaHL = hl.MaHL
    JOIN VE v ON hl.MaHK = v.MaHK
    WHERE v.MaGiaVe = @MaGiaVe;

    -- Cập nhật tổng phụ phí vào bảng GIAVE
    UPDATE GIAVE
    SET TongPhuPhi = @TongPhuPhi
    WHERE MaGiaVe = @MaGiaVe;
END;

--Trigger tự động PROC sp_TinhTongPhuPhi_GiaVe ở bảng HANHLY
CREATE TRIGGER trg_AutoUpdatePhuPhi
ON HANHLY
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaGiaVe CHAR(10);

    -- Lấy MaGiaVe từ bảng VE dựa trên hành lý vừa thêm hoặc cập nhật
    SELECT @MaGiaVe = v.MaGiaVe
    FROM VE v
    JOIN INSERTED i ON v.MaHK = i.MaHK;

    -- Gọi Stored Procedure để tính tổng phụ phí và cập nhật vào bảng GIAVE
    IF @MaGiaVe IS NOT NULL
    BEGIN
        EXEC sp_TinhTongPhuPhi_GiaVe @MaGiaVe;
    END
END;

--Trigger tự động PROC sp_TinhTongPhuPhi_GiaVe ở bảng CHITIETPHUPHI
CREATE TRIGGER trg_AutoUpdatePhuPhi_CTPhuPhi
ON CHITIETPHUPHI
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaGiaVe CHAR(10);

    -- Lấy MaGiaVe từ bảng VE dựa trên hành lý tương ứng trong bảng CHITIETPHUPHI
    SELECT @MaGiaVe = v.MaGiaVe
    FROM VE v
    JOIN HANHLY hl ON v.MaHK = hl.MaHK
    JOIN INSERTED i ON hl.MaHL = i.MaHL;

    -- Gọi Stored Procedure để tính tổng phụ phí và cập nhật vào bảng GIAVE
    IF @MaGiaVe IS NOT NULL
    BEGIN
        EXEC sp_TinhTongPhuPhi_GiaVe @MaGiaVe;
    END
END;



-----------------------------------------------------------------------
--1. Trigger kiểm tra số lượng vé khi thêm mới vé vào bảng VE
--Trigger này sẽ kiểm tra nếu số lượng ghế còn trống đã hết thì không cho phép thêm vé mới.
CREATE TRIGGER KiemTraSoLuongVe
ON VE
FOR INSERT
AS
BEGIN
    DECLARE @MaCB CHAR(10);
    DECLARE @SoVeDaDat INT;
    DECLARE @TongSoGhe INT;

    -- Lấy mã chuyến bay từ bảng được chèn vào
    SELECT @MaCB = MaCB FROM INSERTED;

    -- Lấy tổng số ghế của máy bay và số vé đã đặt
    SELECT @TongSoGhe = MB.TongSoGhe
    FROM MAYBAY MB
    JOIN CHUYENBAY CB ON MB.MaMB = CB.MaMB
    WHERE CB.MaCB = @MaCB;

    SELECT @SoVeDaDat = COUNT(*)
    FROM VE
    WHERE MaCB = @MaCB;

    -- Nếu số vé đã đặt bằng tổng số ghế, thì rollback việc chèn
    IF @SoVeDaDat >= @TongSoGhe
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR(N'Chuyến bay đã hết ghế, không thể đặt thêm vé.', 16, 1);
    END
END;

--2. Trigger cập nhật số ghế còn trống sau khi đặt vé
--Sau khi vé được đặt, trigger này sẽ thực hiện kiểm tra và hiển thị thông báo cảnh báo nếu vé đã hết ghế.
CREATE TRIGGER CapNhatSauDatVe
ON VE
FOR INSERT, DELETE
AS
BEGIN
    DECLARE @MaCB CHAR(10);
    DECLARE @TongSoGhe INT, @SoVeDaDat INT;
    
    -- Lấy mã chuyến bay từ các bản ghi thêm hoặc xóa
    SELECT @MaCB = MaCB FROM INSERTED UNION SELECT @MaCB = MaCB FROM DELETED;

    -- Lấy tổng số ghế của máy bay
    SELECT @TongSoGhe = MB.TongSoGhe
    FROM MAYBAY MB
    JOIN CHUYENBAY CB ON MB.MaMB = CB.MaMB
    WHERE CB.MaCB = @MaCB;

    -- Lấy tổng số vé đã đặt
    SELECT @SoVeDaDat = COUNT(*)
    FROM VE
    WHERE MaCB = @MaCB;

    -- Kiểm tra nếu số vé đã đặt lớn hơn tổng số ghế
    IF @SoVeDaDat > @TongSoGhe
    BEGIN
        RAISERROR(N'Số lượng vé vượt quá số ghế của chuyến bay!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--3. Trigger tự động xóa đánh giá khi hành khách bị xóa
--Khi một hành khách bị xóa, trigger này sẽ tự động xóa các đánh giá liên quan đến hành khách đó.
CREATE TRIGGER XoaNhanXetKhiXoaHanhKhach
ON HANHKHACH
FOR DELETE
AS
BEGIN
    DECLARE @MaHK CHAR(10);

    -- Lấy mã hành khách từ bản ghi bị xóa
    SELECT @MaHK = MaHK FROM DELETED;

    -- Xóa tất cả các nhận xét liên quan đến hành khách đó
    DELETE FROM NHANXET WHERE MaHK = @MaHK;
END;

----4. Trigger tự động cập nhật lương nhân viên khi chức vụ thay đổi
----Nếu chức vụ của một nhân viên thay đổi, trigger này sẽ tự động cập nhật lương của nhân viên dựa trên chức vụ mới.
--CREATE TRIGGER CapNhatLuongKhiThayDoiChucVu
--ON NHANVIEN
--FOR UPDATE
--AS
--BEGIN
--    DECLARE @MaNV CHAR(10), @MaChucVu CHAR(10), @LuongMoi MONEY;

--    -- Lấy mã nhân viên và mã chức vụ mới
--    SELECT @MaNV = MaNV, @MaChucVu = MaChucVu FROM INSERTED;

--    -- Cập nhật lương dựa trên chức vụ mới
--    IF UPDATE(MaChucVu)
--    BEGIN
--        -- Ví dụ: Lương tùy thuộc vào chức vụ
--        IF @MaChucVu = 'CV001'
--            SET @LuongMoi = 20000000;
--        ELSE IF @MaChucVu = 'CV002'
--            SET @LuongMoi = 15000000;
--        ELSE 
--            SET @LuongMoi = 10000000;

--        UPDATE NHANVIEN
--        SET Luong = @LuongMoi
--        WHERE MaNV = @MaNV;
--    END
--END;

--4. Trigger kiểm tra độ tuổi hành khách khi thêm mới
--Trigger này sẽ kiểm tra độ tuổi của hành khách khi thêm mới vào bảng HANHKHACH. Nếu hành khách dưới 18 tuổi, việc thêm mới sẽ bị hủy.
CREATE TRIGGER KiemTraDoTuoiHanhKhach
ON HANHKHACH
FOR INSERT
AS
BEGIN
    DECLARE @NgaySinhHK DATETIME;
    DECLARE @TuoiHK INT;

    -- Lấy ngày sinh của hành khách mới thêm vào
    SELECT @NgaySinhHK = NgaySinhHK FROM INSERTED;

    -- Tính tuổi của hành khách
    SET @TuoiHK = DATEDIFF(YEAR, @NgaySinhHK, GETDATE());

    -- Kiểm tra nếu tuổi dưới 18
    IF @TuoiHK < 18
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR(N'Hành khách phải đủ 18 tuổi để đăng ký tài khoản.', 16, 1);
    END
END;

--5. Trigger tự động cập nhật trạng thái chuyến bay khi đã đến
--Trigger này sẽ tự động cập nhật trạng thái chuyến bay thành "Đã đến" khi giờ đến (GioDen) đã trôi qua.
CREATE TRIGGER CapNhatTrangThaiChuyenBay
ON CHUYENBAY
FOR UPDATE
AS
BEGIN
    DECLARE @MaCB CHAR(10), @GioDen DATE;

    -- Lấy mã chuyến bay và giờ đến
    SELECT @MaCB = MaCB, @GioDen = GioDen FROM INSERTED;

    -- Kiểm tra nếu giờ hiện tại đã qua giờ đến
    IF @GioDen <= GETDATE()
    BEGIN
        RAISERROR(N'Chuyến bay %s đã đến đích.', 16, 1, @MaCB);
    END
END;

-----------------------------------------------------------------------
--						CÀI ĐẶT CÁC PROC
-----------------------------------------------------------------------
--1. Thủ tục đặt vé mới (thêm DATVE mới)
--2. Thủ tục tính số vé đã đặt (thêm VE mới)
--3. Thủ tục thêm thông tin hành khách khi hành khách đặt vé mới (thêm HANHKHACH)

--1. Thủ tục thêm hành khách mới
CREATE PROC sp_ThemHanhKhach
    @MaHK CHAR(10),
    @TenHK NVARCHAR(50),
    @DiaChi NVARCHAR(50),
    @SDT CHAR(11),
    @CCCD CHAR(20),
    @HoChieu CHAR(20),
    @NgaySinh DATETIME,
    @IDTaiKhoan CHAR(20)
AS
BEGIN
    INSERT INTO HANHKHACH (MaHK, TenHK, DiaChi, SDT, CCCD, HoChieu, NgaySinh, IDTaiKhoan)
    VALUES (@MaHK, @TenHK, @DiaChi, @SDT, @CCCD, @HoChieu, @NgaySinh, @IDTaiKhoan);
END

--2. Thủ tục thêm chuyến bay mới
CREATE PROC sp_ThemChuyenBay
    @MaCB CHAR(10),
    @GioBay DATE,
    @GioDen DATE,
    @GioDuKien DATE,
    @MaMB CHAR(10),
    @MaChangBay CHAR(10)
AS
BEGIN
    INSERT INTO CHUYENBAY (MaCB, GioBay, GioDen, ThoiGianBay, MaMB, MaChangBay)
    VALUES (@MaCB, @GioBay, @GioDen, @GioDuKien, @MaMB, @MaChangBay);
END

--3. Thủ tục đặt vé máy bay
CREATE PROC sp_DatVeMayBay
    @MaVe CHAR(10),
    @GiaVe MONEY,
    @DonViTien NCHAR(10),
    @ViTriGhe CHAR(10),
    @MaCB CHAR(10),
    @MaHK CHAR(10),
    @MaDV CHAR(10)
AS
BEGIN
    INSERT INTO VE (MaVe, GiaVe, DonViTien, ViTriGhe, MaCB, MaHK, MaDV)
    VALUES (@MaVe, @GiaVe, @DonViTien, @ViTriGhe, @MaCB, @MaHK, @MaDV);
END

--4. Thủ tục cập nhật thông tin chuyến bay
CREATE PROC sp_CapNhatChuyenBay
    @MaCB CHAR(10),
    @GioBay DATE,
    @GioDen DATE,
    @GioDuKien DATE
AS
BEGIN
    UPDATE CHUYENBAY
    SET GioBay = @GioBay, GioDen = @GioDen, GioDuKien = @GioDuKien
    WHERE MaCB = @MaCB;
END

--5. Thủ tục hủy vé
CREATE PROC sp_HuyVe
    @MaVe CHAR(10)
AS
BEGIN
    DELETE FROM VE WHERE MaVe = @MaVe;
END

--6. Thủ tục tìm kiếm chuyến bay theo mã sân bay đi và sân bay đến
CREATE PROC sp_TimChuyenBay
    @MaSBdi CHAR(10),
    @MaSBden CHAR(10)
AS
BEGIN
    SELECT * 
    FROM CHUYENBAY CB
    JOIN CHANGBAY ChB ON CB.MaChangBay = ChB.MaChangBay
    WHERE ChB.MaSBdi = @MaSBdi AND ChB.MaSBden = @MaSBden;
END

--7. Thủ tục xem danh sách vé của hành khách
CREATE PROC sp_XemVeHanhKhach
    @MaHK CHAR(10)
AS
BEGIN
    SELECT * 
    FROM VE
    WHERE MaHK = @MaHK;
END

--8. Thủ tục thêm đánh giá chuyến bay
CREATE PROC ThemNhanXet
    @MaHK CHAR(10),
    @MaCB CHAR(10),
    @NDNhanXet NVARCHAR(1000),
    @DiemDanhGia INT
AS
BEGIN
    INSERT INTO NHANXET (MaHK, MaCB, NDNhanXet, DiemDanhGia)
    VALUES (@MaHK, @MaCB, @NDNhanXet, @DiemDanhGia);
END

-----------------------------------------------------------------------
--						CÀI ĐẶT CÁC FUNCTION
-----------------------------------------------------------------------
--1. Hàm tính tổng số vé đã đặt cho một chuyến bay
CREATE FUNCTION TongSoVeDaDat(@MaCB CHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @SoVe INT;
    SELECT @SoVe = COUNT(*)
    FROM VE
    WHERE MaCB = @MaCB;
    
    RETURN @SoVe;
END

--2. Hàm tính tổng số ghế còn trống trên một chuyến bay
CREATE FUNCTION TongSoGheConTrong(@MaCB CHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @TongSoGhe INT;
    DECLARE @SoVeDaDat INT;

    -- Lấy tổng số ghế của máy bay
    SELECT @TongSoGhe = MB.TongSoGhe
    FROM MAYBAY MB
    JOIN CHUYENBAY CB ON MB.MaMB = CB.MaMB
    WHERE CB.MaCB = @MaCB;

    -- Lấy tổng số vé đã đặt
    SELECT @SoVeDaDat = COUNT(*)
    FROM VE
    WHERE MaCB = @MaCB;

    -- Trả về số ghế còn trống
    RETURN @TongSoGhe - @SoVeDaDat;
END

--3. Hàm tính tổng tiền vé của một hành khách cho một chuyến bay
CREATE FUNCTION TongTienVeHanhKhach(@MaHK CHAR(10), @MaCB CHAR(10))
RETURNS MONEY
AS
BEGIN
    DECLARE @TongTien MONEY;
    
    SELECT @TongTien = SUM(GiaVe)
    FROM VE
    WHERE MaHK = @MaHK AND MaCB = @MaCB;
    
    RETURN @TongTien;
END

--4. Hàm lấy loại máy bay của một chuyến bay
CREATE FUNCTION LayLoaiMayBay(@MaCB CHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @LoaiMB NVARCHAR(50);

    SELECT @LoaiMB = MB.LoaiMB
    FROM MAYBAY MB
    JOIN CHUYENBAY CB ON MB.MaMB = CB.MaMB
    WHERE CB.MaCB = @MaCB;

    RETURN @LoaiMB;
END

--5. Hàm kiểm tra ghế có còn trống trên một chuyến bay
CREATE FUNCTION KiemTraGheTrong(@MaCB CHAR(10), @ViTriGhe CHAR(10))
RETURNS BIT
AS
BEGIN
    DECLARE @GheTrong BIT;

    IF EXISTS (SELECT 1 FROM VE WHERE MaCB = @MaCB AND ViTriGhe = @ViTriGhe)
    BEGIN
        SET @GheTrong = 0; -- Ghế đã được đặt
    END
    ELSE
    BEGIN
        SET @GheTrong = 1; -- Ghế còn trống
    END

    RETURN @GheTrong;
END

--6. Hàm tính tổng cân hành lý của một hành khách trên chuyến bay
CREATE FUNCTION TongCanHanhLy(@MaHK CHAR(10), @MaCB CHAR(10))
RETURNS FLOAT
AS
BEGIN
    DECLARE @TongCan FLOAT;

    SELECT @TongCan = SUM(SoKG)
    FROM HANHLY
    WHERE MaHK = @MaHK AND MaCB = @MaCB;

    RETURN @TongCan;
END

--7. Hàm lấy đánh giá trung bình của một chuyến bay
CREATE FUNCTION DiemDanhGiaTrungBinh(@MaCB CHAR(10))
RETURNS FLOAT
AS
BEGIN
    DECLARE @DiemTB FLOAT;

    SELECT @DiemTB = AVG(DiemDanhGia)
    FROM NHANXET
    WHERE MaCB = @MaCB;

    RETURN @DiemTB;
END

--8. Hàm kiểm tra tài khoản có phải là nhân viên hay không
CREATE FUNCTION KiemTraNhanVien(@IDTaiKhoan CHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @IsNhanVien BIT;

    IF EXISTS (SELECT 1 FROM QLTaiKhoan WHERE IDTaiKhoan = @IDTaiKhoan AND LoaiTK = N'NHANVIEN')
    BEGIN
        SET @IsNhanVien = 1; -- Là nhân viên
    END
    ELSE
    BEGIN
        SET @IsNhanVien = 0; -- Không phải nhân viên
    END

    RETURN @IsNhanVien;
END

-----------------------------------------------------------------------
--						CÀI ĐẶT CÁC CURSOR
-----------------------------------------------------------------------
--1. Cursor để Duyệt Qua Tất Cả Các Vé Máy Bay
DECLARE @MaVe CHAR(10)
DECLARE @GiaVe MONEY
DECLARE @DonViTien NCHAR(10)
DECLARE @ViTriGhe CHAR(10)
DECLARE @MaHK CHAR(10)
DECLARE @MaDV CHAR(10)

-- Khai báo cursor để lấy thông tin từ bảng VE
DECLARE VeCursor CURSOR FOR
SELECT MaVe, GiaVe, DonViTien, ViTriGhe, MaCB, MaHK, MaDV
FROM VE

OPEN VeCursor

FETCH NEXT FROM VeCursor INTO @MaVe, @GiaVe, @DonViTien, @ViTriGhe, @MaCB, @MaHK, @MaDV

WHILE @@FETCH_STATUS = 0
BEGIN
    -- In ra thông tin vé
    PRINT N'Mã Vé: ' + @MaVe +
          N', Giá Vé: ' + CAST(@GiaVe AS NVARCHAR(50)) +
          N', Đơn Vị Tiền: ' + @DonViTien +
          N', Vị Trí Ghế: ' + @ViTriGhe +
          N', Mã Chuyến Bay: ' + @MaCB +
          N', Mã Hành Khách: ' + @MaHK +
          N', Mã Đặt Vé: ' + @MaDV

    FETCH NEXT FROM VeCursor INTO @MaVe, @GiaVe, @DonViTien, @ViTriGhe, @MaCB, @MaHK, @MaDV
END

CLOSE VeCursor
DEALLOCATE VeCursor

--2. Cursor để tính tổng doanh thu cho từng chuyến bay
DECLARE @MaCB CHAR(10)
DECLARE @TongDoanhThu FLOAT

-- Khai báo cursor để duyệt qua các vé đã đặt
DECLARE DoanhThuCursor CURSOR FOR
SELECT MaCB FROM CHUYENBAY

-- Mở cursor
OPEN DoanhThuCursor

-- Lấy từng bản ghi từ cursor
FETCH NEXT FROM DoanhThuCursor INTO @MaCB

-- Duyệt qua tất cả các bản ghi
WHILE @@FETCH_STATUS = 0
BEGIN
	-- Tính tổng doanh thu
    SELECT @TongDoanhThu = SUM(ThanhTien)
    FROM DATVE
    WHERE MaCB = @MaCB

	-- In ra tổng doanh thu
    PRINT 'Chuyến bay: ' + @MaCB + ' - Tổng doanh thu: ' + CAST(@TongDoanhThu AS NVARCHAR(50))

	-- Lấy bản ghi tiếp theo
    FETCH NEXT FROM DoanhThuCursor INTO @MaCB
END

-- Đóng và giải phóng cursor
CLOSE DoanhThuCursor
DEALLOCATE DoanhThuCursor

--3. Cursor để cập nhật thông tin hành lý ký gửi cho từng hành khách
DECLARE @MaHK CHAR(10)
DECLARE @MaCB CHAR(10)
DECLARE @SoKG FLOAT

DECLARE HanhLyCursor CURSOR FOR
SELECT hk.MaHK, hl.MaCB, hl.SoKG
FROM HANHKHACH hk
JOIN HANHLY hl ON hk.MaHK = hl.MaHK

OPEN HanhLyCursor

FETCH NEXT FROM HanhLyCursor INTO @MaHK, @MaCB, @SoKG

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Cập nhật thông tin hành lý ký gửi hoặc thực hiện tác vụ khác
    UPDATE HANHLY
    SET SoKG = SoKG + 5 -- Ví dụ: tăng thêm 5 kg
    WHERE MaHK = @MaHK AND MaCB = @MaCB

    PRINT 'Cập nhật hành lý cho hành khách: ' + @MaHK + ' trên chuyến bay: ' + @MaCB

    FETCH NEXT FROM HanhLyCursor INTO @MaHK, @MaCB, @SoKG
END

CLOSE HanhLyCursor
DEALLOCATE HanhLyCursor

--4. Cursor để ghi nhận thông tin đánh giá cho từng chuyến bay
DECLARE @MaCB CHAR(10)
DECLARE @DiemDanhGia FLOAT

DECLARE DanhGiaCursor CURSOR FOR
SELECT MaCB, AVG(DiemDanhGia)
FROM NHANXET
GROUP BY MaCB

OPEN DanhGiaCursor

FETCH NEXT FROM DanhGiaCursor INTO @MaCB, @DiemDanhGia

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Cập nhật thông tin đánh giá vào một bảng hoặc thực hiện tác vụ khác
    PRINT 'Chuyến bay: ' + @MaCB + ' - Điểm đánh giá trung bình: ' + CAST(@DiemDanhGia AS NVARCHAR(50))

    FETCH NEXT FROM DanhGiaCursor INTO @MaCB, @DiemDanhGia
END

CLOSE DanhGiaCursor
DEALLOCATE DanhGiaCursor

--5. Cursor để thống kê số lượng vé hủy cho từng chuyến bay
DECLARE @MaCB CHAR(10)
DECLARE @SoVeHuy INT

DECLARE VeHuyCursor CURSOR FOR
SELECT MaCB FROM CHUYENBAY

OPEN VeHuyCursor

FETCH NEXT FROM VeHuyCursor INTO @MaCB

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @SoVeHuy = COUNT(*)
    FROM DATVE
    WHERE MaCB = @MaCB AND TrangThai = 'Hủy' -- Cần đảm bảo cột TrangThai có trong bảng DATVE

    PRINT 'Chuyến bay: ' + @MaCB + ' - Số vé đã hủy: ' + CAST(@SoVeHuy AS NVARCHAR(10))

    FETCH NEXT FROM VeHuyCursor INTO @MaCB
END

CLOSE VeHuyCursor
DEALLOCATE VeHuyCursor


----5. Cursor để duyệt qua nhận xét của hành khách và cập nhật điểm đánh giá trung bình
----Cursor này sẽ duyệt qua bảng NHANXET để tính điểm đánh giá trung bình của các chuyến bay.
--DECLARE @MaCB CHAR(10), @TongDiem INT, @SoNhanXet INT, @DiemTB FLOAT;

---- Khai báo cursor để duyệt qua các chuyến bay trong bảng nhận xét
--DECLARE NhanXetCursor CURSOR FOR
--SELECT MaCB
--FROM NHANXET
--GROUP BY MaCB;

---- Mở cursor
--OPEN NhanXetCursor;

---- Lấy từng bản ghi từ cursor
--FETCH NEXT FROM NhanXetCursor INTO @MaCB;

---- Duyệt qua tất cả các bản ghi
--WHILE @@FETCH_STATUS = 0
--BEGIN
--    -- Tính tổng điểm và số lượng nhận xét cho chuyến bay
--    SELECT @TongDiem = SUM(DiemDanhGia), @SoNhanXet = COUNT(*)
--    FROM NHANXET
--    WHERE MaCB = @MaCB;

--    -- Tính điểm trung bình
--    SET @DiemTB = CAST(@TongDiem AS FLOAT) / @SoNhanXet;

--    -- In ra thông tin chuyến bay và điểm đánh giá trung bình
--    PRINT 'Chuyến bay: ' + @MaCB + ', Điểm đánh giá trung bình: ' + CAST(@DiemTB AS NVARCHAR);
    
--    -- Lấy bản ghi tiếp theo
--    FETCH NEXT FROM NhanXetCursor INTO @MaCB;
--END;

---- Đóng và giải phóng cursor
--CLOSE NhanXetCursor;
--DEALLOCATE NhanXetCursor;

-----------------------------------------------------------------------
--						MÔ TẢ YÊU CẦU THỐNG KÊ
-----------------------------------------------------------------------
--1. Thống kê số lượng vé bán ra theo chuyến bay
SELECT 
    cb.MaCB,
    sb1.TenSB AS SBDi,
    sb2.TenSB AS SBDen,
    cb.NgayBay,
    COUNT(dv.MaDV) AS SoVeDaBan
FROM 
    CHUYENBAY cb
LEFT JOIN 
    DATVE dv ON cb.MaCB = dv.MaCB
LEFT JOIN 
    SANBAY sb1 ON cb.MaSBdi = sb1.MaSB
LEFT JOIN 
    SANBAY sb2 ON cb.MaSBden = sb2.MaSB
GROUP BY 
    cb.MaCB, sb1.TenSB, sb2.TenSB, cb.NgayBay;

--2. Thống kê doanh thu từ vé bán ra
SELECT 
    MONTH(dv.NgayDatVe) AS Thang,
    YEAR(dv.NgayDatVe) AS Nam,
    SUM(dv.ThanhTien) AS TongDoanhThu
FROM 
    DATVE dv
GROUP BY 
    MONTH(dv.NgayDatVe), YEAR(dv.NgayDatVe)
ORDER BY 
    Nam, Thang;

--3. Thống kê số lượng ghế trống trên mỗi chuyến bay
SELECT 
    cb.MaCB,
    mb.TongSoGhe,
    COUNT(dv.MaDV) AS SoVeDaBan,
    (mb.TongSoGhe - COUNT(dv.MaDV)) AS SoGheTrong
FROM 
    CHUYENBAY cb
JOIN 
    MAYBAY mb ON cb.MaMB = mb.MaMB
LEFT JOIN 
    DATVE dv ON cb.MaCB = dv.MaCB
GROUP BY 
    cb.MaCB, mb.TongSoGhe;

--4. Thống kê hành khách theo sân bay
SELECT 
    sb.TenSB,
    COUNT(hk.MaHK) AS TongHanhKhach
FROM 
    HANHKHACH hk
JOIN 
    DATVE dv ON hk.MaHK = dv.MaHK
JOIN 
    CHUYENBAY cb ON dv.MaCB = cb.MaCB
JOIN 
    SANBAY sb ON cb.MaSBdi = sb.MaSB
GROUP BY 
    sb.TenSB;

--5. Thống kê đánh giá của hành khách
SELECT 
    cb.MaCB,
    AVG(nx.DiemDanhGia) AS DiemDanhGiaTrungBinh,
    COUNT(nx.MaHK) AS SoLuongDanhGia
FROM 
    NHANXET nx
JOIN 
    CHUYENBAY cb ON nx.MaCB = cb.MaCB
GROUP BY 
    cb.MaCB;

--6. Thống kê hành lý ký gửi
SELECT 
    cb.MaCB,
    SUM(hl.SoKG) AS TongTrongLuongHanhLy
FROM 
    HANHLY hl
JOIN 
    CHUYENBAY cb ON hl.MaCB = cb.MaCB
GROUP BY 
    cb.MaCB;

----6. Thống kê hành lý ký gửi theo chuyến bay
----Yêu cầu: Thống kê tổng trọng lượng hành lý đã ký gửi trên mỗi chuyến bay và số lượng hành lý
---- Tổng trọng lượng hành lý trên mỗi chuyến bay
--SELECT MaCB, SUM(SoKG) AS TongTrongLuongHanhLy
--FROM HANHLY
--GROUP BY MaCB;

---- Số lượng hành lý ký gửi theo chuyến bay
--SELECT MaCB, COUNT(MaHL) AS SoLuongHanhLy
--FROM HANHLY
--GROUP BY MaCB;

--7. Thống kê doanh thu theo phương thức thanh toán
SELECT 
    dv.PhươngThứcThanhToán, -- Cột này cần có trong bảng DATVE
    SUM(dv.ThanhTien) AS TongDoanhThu
FROM 
    DATVE dv
GROUP BY 
    dv.PhươngThứcThanhToán;

--8. Thống kê tỷ lệ hủy vé
sql
Sao chép mã
SELECT 
    cb.MaCB,
    COUNT(dv.MaDV) AS TongVeDaBan,
    COUNT(CASE WHEN dv.TrangThai = N'Hủy' THEN 1 END) AS TongVeBiHuy,
    (COUNT(CASE WHEN dv.TrangThai = N'Hủy' THEN 1 END) * 1.0 / COUNT(dv.MaDV)) * 100 AS TyLeHuy
FROM 
    CHUYENBAY cb
LEFT JOIN 
    DATVE dv ON cb.MaCB = dv.MaCB
GROUP BY 
    cb.MaCB;

-----------------------------------------------------------------------
--					  XÂY DỰNG CÁC CẤU TRÚC VIEW
-----------------------------------------------------------------------
--1. View: Thông tin chi tiết về chuyến bay

--Thông tin chi tiết về chuyến bay, bao gồm loại máy bay, hãng, và ngày giờ bay.
CREATE VIEW V_ThongTinChuyenBay AS
SELECT 
    cb.MaCB, 
    cb.GioBay, 
    cb.GioDen, 
    mb.LoaiMB, 
    mb.Hang AS HangMayBay, 
    sb_di.TenSB AS SanBayDi, 
    sb_den.TenSB AS SanBayDen
FROM CHUYENBAY cb
JOIN MAYBAY mb ON cb.MaMB = mb.MaMB
JOIN CHANGBAY chb ON cb.MaChangBay = chb.MaChangBay
JOIN SANBAY sb_di ON chb.MaSBdi = sb_di.MaSB
JOIN SANBAY sb_den ON chb.MaSBden = sb_den.MaSB;

--2. View: Thông tin vé đã bán và hành khách

--Thông tin về vé bán ra, kèm theo thông tin hành khách tương ứng và chuyến bay.
CREATE VIEW V_VeBanRaHanhKhach AS
SELECT 
    v.MaVe, 
    v.GiaVe, 
    v.DonViTien, 
    v.ViTriGhe, 
    hk.TenHK, 
    hk.SDT, 
    cb.MaCB, 
    cb.GioBay, 
    sb_di.TenSB AS SanBayDi, 
    sb_den.TenSB AS SanBayDen
FROM VE v
JOIN HANHKHACH hk ON v.MaHK = hk.MaHK
JOIN CHUYENBAY cb ON v.MaCB = cb.MaCB
JOIN CHANGBAY chb ON cb.MaChangBay = chb.MaChangBay
JOIN SANBAY sb_di ON chb.MaSBdi = sb_di.MaSB
JOIN SANBAY sb_den ON chb.MaSBden = sb_den.MaSB;

--3. View: Thống kê số lượng vé đã bán và ghế trống trên mỗi chuyến bay

--Thống kê số lượng vé đã bán và số lượng ghế còn trống trên mỗi chuyến bay.
CREATE VIEW V_ThongKeVeVaGheTrenChuyenBay AS
SELECT 
    cb.MaCB, 
    COUNT(v.MaVe) AS SoVeDaBan, 
    (mb.TongSoGhe - COUNT(v.MaVe)) AS SoGheTrong
FROM CHUYENBAY cb
JOIN MAYBAY mb ON cb.MaMB = mb.MaMB
LEFT JOIN VE v ON cb.MaCB = v.MaCB
GROUP BY cb.MaCB, mb.TongSoGhe;

--4. View: Doanh thu theo chuyến bay

--Tính toán tổng doanh thu từ vé bán ra cho mỗi chuyến bay.
CREATE VIEW V_DoanhThuTheoChuyenBay AS
SELECT 
    cb.MaCB, 
    SUM(v.GiaVe) AS TongDoanhThu
FROM VE v
JOIN CHUYENBAY cb ON v.MaCB = cb.MaCB
GROUP BY cb.MaCB;

--5. View: Thống kê hành khách và số lượng hành lý ký gửi trên chuyến bay

--Thông tin hành khách cùng với số lượng và trọng lượng hành lý ký gửi trên chuyến bay.
CREATE VIEW V_ThongKeHanhLyTheoChuyenBay AS
SELECT 
    cb.MaCB, 
    hk.MaHK, 
    hk.TenHK, 
    COUNT(hl.MaHL) AS SoLuongHanhLy, 
    SUM(hl.SoKG) AS TongTrongLuongHanhLy
FROM HANHKHACH hk
JOIN HANHLY hl ON hk.MaHK = hl.MaHK
JOIN CHUYENBAY cb ON hl.MaCB = cb.MaCB
GROUP BY cb.MaCB, hk.MaHK, hk.TenHK;

--6. View: Thống kê số lượng vé bán ra theo sân bay

--Tính toán số lượng vé đã bán theo từng sân bay đi.
CREATE VIEW V_ThongKeVeTheoSanBay AS
SELECT 
    sb.TenSB AS SanBayDi, 
    COUNT(v.MaVe) AS SoVeDaBan
FROM VE v
JOIN CHUYENBAY cb ON v.MaCB = cb.MaCB
JOIN CHANGBAY chb ON cb.MaChangBay = chb.MaChangBay
JOIN SANBAY sb ON chb.MaSBdi = sb.MaSB
GROUP BY sb.TenSB;

--7. View: Thống kê đánh giá của hành khách về chuyến bay

--Tính toán điểm đánh giá trung bình và số lượng nhận xét của hành khách trên mỗi chuyến bay.
CREATE VIEW V_ThongKeDanhGiaChuyenBay AS
SELECT 
    cb.MaCB, 
    AVG(nx.DiemDanhGia) AS DiemDanhGiaTrungBinh, 
    COUNT(nx.MaHK) AS SoLuongNhanXet
FROM NHANXET nx
JOIN CHUYENBAY cb ON nx.MaCB = cb.MaCB
GROUP BY cb.MaCB;

--8. View: Thống kê doanh thu vé theo tháng, quý, năm
--Tính toán doanh thu từ vé bán ra theo từng tháng, quý, năm.

--View doanh thu theo tháng:
CREATE VIEW V_DoanhThuTheoThang AS
SELECT 
    YEAR(v.GioBay) AS Nam, 
    MONTH(v.GioBay) AS Thang, 
    SUM(v.GiaVe) AS DoanhThu
FROM VE v
JOIN CHUYENBAY cb ON v.MaCB = cb.MaCB
GROUP BY YEAR(v.GioBay), MONTH(v.GioBay);

--View doanh thu theo quý:
CREATE VIEW V_DoanhThuTheoQuy AS
SELECT 
    YEAR(v.GioBay) AS Nam, 
    CEILING(MONTH(v.GioBay)/3.0) AS Quy, 
    SUM(v.GiaVe) AS DoanhThu
FROM VE v
JOIN CHUYENBAY cb ON v.MaCB = cb.MaCB
GROUP BY YEAR(v.GioBay), CEILING(MONTH(v.GioBay)/3.0);

