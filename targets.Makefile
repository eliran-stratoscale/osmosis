TARGET_osmosis = cpp/Osmosis/main.cpp cpp/Osmosis/cppnetlib.cpp
osmosis_LIBRARIES = -pthread \
	$(STATIC_BOOST_LIBS_DIR)/libboost_regex$(BOOST_MT).a \
	$(STATIC_BOOST_LIBS_DIR)/libboost_filesystem$(BOOST_MT).a \
	$(STATIC_BOOST_LIBS_DIR)/libboost_system$(BOOST_MT).a \
	$(STATIC_BOOST_LIBS_DIR)/libboost_program_options$(BOOST_MT).a \
	-lcrypto \
	$(STATIC_BOOST_LIBS_DIR)/libboost_thread$(BOOST_MT).a

TARGET_testtaskqueue = cpp/Common/WhiteboxTests/testtaskqueue.cpp
testtaskqueue_LIBRARIES = -pthread $(STATIC_BOOST_LIBS_DIR)/libboost_system$(BOOST_MT).a
