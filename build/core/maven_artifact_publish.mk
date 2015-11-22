# Copyright (C) 2015-2016 The MoKee Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

full_target := $(call doc-timestamp-for,$(LOCAL_MODULE))

ifeq ($(strip $(LOCAL_MAVEN_POM)),)
  $(error LOCAL_MAVEN_POM not defined.)
endif
ifeq ($(strip $(LOCAL_MAVEN_REPO)),)
  $(error LOCAL_MAVEN_REPO not defined.)
endif
ifeq ($(strip $(LOCAL_MAVEN_FILE_PATH)),)
  $(error LOCAL_MAVEN_FILE_PATH not defined.)
endif
ifeq ($(strip $(LOCAL_MAVEN_REPO_ID)),)
  $(error LOCAL_MAVEN_REPO_ID not defined.)
endif


$(full_target): pomfile := $(LOCAL_MAVEN_POM)
$(full_target): repo := $(LOCAL_MAVEN_REPO)
$(full_target): path_to_file := $(LOCAL_MAVEN_FILE_PATH)
$(full_target): repoId := $(LOCAL_MAVEN_REPO_ID)
$(full_target): classifier := $(LOCAL_MAVEN_CLASSIFIER)
$(full_target): sources := $(LOCAL_MAVEN_SOURCES)
$(full_target): javadoc := $(LOCAL_MAVEN_JAVADOC)

$(full_target):
	$(hide) mvn -e -X gpg:sign-and-deploy-file \
		    -DpomFile=$(pomfile) \
			-Durl=$(repo) \
			-Dfile=$(path_to_file) \
			-DrepositoryId=$(repoId) \
			-Dclassifier=$(classifier) \
			-Dsources=$(sources) \
			-Djavadoc=$(javadoc)
	@echo -e ${CL_GRN}"Publishing:"${CL_RST}" $@"
$(LOCAL_MODULE) : $(full_target)